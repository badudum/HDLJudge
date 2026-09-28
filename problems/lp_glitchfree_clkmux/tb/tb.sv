`timescale 1ns/1ps
`define FAIL(args) begin if (errors == 0) $sformat args ; errors = errors + 1; end
module tb;
    integer errors;
    reg [8*240-1:0] detail;
    task start_test; begin errors = 0; detail = ""; end endtask
    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d errors)", name, detail, errors);
        end
    endtask

    reg  c0 = 0, c1 = 0, rst = 1, sel = 0, follow = 0, wchk = 0;
    wire q;
    real last_edge;
    integer k, nq;
    clk_mux_gf dut (.clk0(c0), .clk1(c1), .rst(rst), .sel(sel), .clk_out(q));
    always #5 c0 = ~c0;                               // 10 ns
    initial begin #1.3; forever #8 c1 = ~c1; end      // 16 ns, unrelated phase

    always @(q) begin
        if (wchk && ($realtime - last_edge) < 4.99) `FAIL((detail, "glitch: clk_out phase of only %.2f ns ending at %.2f ns (minimum 5 ns)", $realtime - last_edge, $realtime))
        last_edge = $realtime;
        nq = nq + 1;
    end
    initial begin
        #0.25;
        forever begin
            #0.5;
            if (follow && q !== (sel ? c1 : c0)) `FAIL((detail, "t=%.2f ns: clk_out = %b but the selected clock (sel=%b) is %b", $realtime, q, sel, sel ? c1 : c0))
        end
    end

    task settle_and_follow(input s, input [8*80-1:0] name);
        begin
            start_test;
            sel = s; #140;
            follow = 1; #400; follow = 0;
            end_test(name);
        end
    endtask

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        last_edge = 0.0; nq = 0;
        start_test;
        #40;
        if (q !== 1'b0) `FAIL((detail, "clk_out = %b during reset (expected 0)", q))
        end_test("low during reset");
        #3.1 rst = 0;
        #1 wchk = 1;
        settle_and_follow(0, "follows clk0 when sel = 0");
        settle_and_follow(1, "follows clk1 when sel = 1");
        settle_and_follow(0, "switches back to clk0");

        start_test;
        for (k = 0; k < 150; k = k + 1) begin
            #(131.1 + ($random & 127) * 1.7);
            sel = ~sel;
        end
        #150;
        follow = 1; #300; follow = 0;
        end_test("no glitch during 150 random switches");
        $display("TB_DONE");
        $finish;
    end
endmodule
