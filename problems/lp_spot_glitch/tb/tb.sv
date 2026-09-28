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

    reg  rst = 0;
    wire gclk;
    wire [7:0] count;
    reg  [7:0] rc;
    reg  cchk = 0;

    reg  clk = 0, chk = 0;
    reg  en = 1'bx, te = 1'b0;
    reg  l;
    integer k, n;
    always #5 clk = ~clk;
    always @(*) if (!clk) l = en | te;          // reference latch
    wire gref = clk & l;

    initial begin
        #0.25;
        forever begin
            #0.5;
            if (chk && gclk !== gref) `FAIL((detail, "t=%.2f ns: gclk = %b, expected %b (clk=%b, en=%b, latched enable=%b)", $realtime, gclk, gref, clk, en, l))
        end
    end

    gated_counter dut (.clk(clk), .rst(rst), .en(en), .gclk(gclk), .count(count));
    always @(posedge gref or posedge rst) if (rst) rc <= 0; else rc <= rc + 1;
    initial begin
        #0.35;
        forever begin
            #0.5;
            if (cchk && (count !== rc || $isunknown(count))) `FAIL((detail, "t=%.2f ns: count = %0d, expected %0d", $realtime, count, rc))
        end
    end

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        #0.25 rst = 1;
        #0.75 en = 0;
        #10 rst = 0;
        @(negedge clk); #1; chk = 1; cchk = 1;

        start_test;
        en = 1; repeat (8) @(posedge clk);
        for (k = 0; k < 30; k = k + 1) begin
            @(posedge clk); #(0.5 + 0.5 * ($random & 7)); en = ~en;
        end
        @(negedge clk); #1;
        end_test("gclk never glitches");

        start_test;
        for (k = 0; k < 800; k = k + 1) begin
            n = $random & 31;
            #(0.5 * n + 0.5);
            en = ~en;
        end
        #20;
        end_test("count matches the enabled clock edges");
        $display("TB_DONE");
        $finish;
    end
endmodule
