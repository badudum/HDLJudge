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

    reg  clk = 0, rst = 1, men = 0;
    wire q;
    integer merr, nrise, k;
    wire [8*160-1:0] mmsg;

    clk_div3 dut (.clk(clk), .rst(rst), .clk_out(q));
    hwlc_clkmon #(.P(30.0), .H(15.0), .GRID(5.0), .OFS(0.0)) mon (.q(q), .en(men), .errs(merr), .nrise(nrise), .msg(mmsg));
    always #5 clk = ~clk;

    task measure(input integer periods, input [8*80-1:0] name);
        begin
            start_test;
            men = 1;
            repeat (3 * periods) @(posedge clk);
            #1 men = 0;
            if (merr != 0) `FAIL((detail, "%0s", mmsg))
            else if (nrise < periods - 1) `FAIL((detail, "only %0d rising edges of clk_out in %0d clock cycles (expected %0d)", nrise, 3 * periods, periods))
            end_test(name);
        end
    endtask

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        start_test;
        repeat (2) @(posedge clk);
        for (k = 0; k < 60; k = k + 1) begin
            #1;
            if (q !== 1'b0) `FAIL((detail, "clk_out = %b at t=%.1f ns while rst is held (expected 0)", q, $realtime))
        end
        end_test("held low during reset");

        @(negedge clk) rst = 0;
        repeat (9) @(posedge clk);
        @(negedge clk);
        measure(20, "period is 3 clock cycles");
        measure(20, "50% duty cycle");

        start_test;
        @(negedge clk) rst = 1;
        repeat (2) @(posedge clk);
        #6;
        for (k = 0; k < 40; k = k + 1) begin
            #1;
            if (q !== 1'b0) `FAIL((detail, "clk_out = %b at t=%.1f ns, 2 cycles after rst was asserted mid-run", q, $realtime))
        end
        end_test("reset mid-run");

        @(negedge clk) rst = 0;
        repeat (9) @(posedge clk);
        @(posedge clk);
        measure(40, "restarts cleanly after reset");
        $display("TB_DONE");
        $finish;
    end
endmodule

module hwlc_clkmon #(parameter real P = 30.0, parameter real H = 15.0, parameter real GRID = 5.0, parameter real OFS = 0.0)
                    (input wire q, input wire en, output integer errs, output integer nrise, output reg [8*160-1:0] msg);
    real last_r;
    reg  have_r;
    function real absr(input real x); absr = x < 0.0 ? -x : x; endfunction
    function real fm(input real a); fm = (a - OFS) - GRID * $floor((a - OFS) / GRID + 0.5); endfunction
    initial begin errs = 0; nrise = 0; have_r = 0; msg = ""; end
    always @(posedge en) begin errs = 0; nrise = 0; have_r = 0; msg = ""; end
    always @(posedge q) if (en) begin
        nrise = nrise + 1;
        if (have_r && absr($realtime - last_r - P) > 0.01) begin
            if (errs == 0) $sformat(msg, "rising edges at %.2f ns and %.2f ns: period %.2f ns, expected %.2f ns", last_r, $realtime, $realtime - last_r, P);
            errs = errs + 1;
        end
        if (absr(fm($realtime)) > 0.01) begin
            if (errs == 0) $sformat(msg, "clk_out edge at %.2f ns is not aligned with an input clock edge", $realtime);
            errs = errs + 1;
        end
        last_r = $realtime; have_r = 1;
    end
    always @(negedge q) if (en) begin
        if (have_r && absr($realtime - last_r - H) > 0.01) begin
            if (errs == 0) $sformat(msg, "high from %.2f ns to %.2f ns: %.2f ns, expected %.2f ns", last_r, $realtime, $realtime - last_r, H);
            errs = errs + 1;
        end
        if (absr(fm($realtime)) > 0.01) begin
            if (errs == 0) $sformat(msg, "clk_out edge at %.2f ns is not aligned with an input clock edge", $realtime);
            errs = errs + 1;
        end
    end
endmodule
