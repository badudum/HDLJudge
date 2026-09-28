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
    wire [6:0] q;
    integer e2, e3, e4, e5, e7, e8, e16, r2, r3, r4, r5, r7, r8, r16;
    wire [8*160-1:0] m2, m3, m4, m5, m7, m8, m16;
    integer k;

    clk_div_n #(.N(2))  d2  (.clk(clk), .rst(rst), .clk_out(q[0]));
    clk_div_n #(.N(3))  d3  (.clk(clk), .rst(rst), .clk_out(q[1]));
    clk_div_n #(.N(4))  d4  (.clk(clk), .rst(rst), .clk_out(q[2]));
    clk_div_n #(.N(5))  d5  (.clk(clk), .rst(rst), .clk_out(q[3]));
    clk_div_n #(.N(7))  d7  (.clk(clk), .rst(rst), .clk_out(q[4]));
    clk_div_n #(.N(8))  d8  (.clk(clk), .rst(rst), .clk_out(q[5]));
    clk_div_n #(.N(16)) d16 (.clk(clk), .rst(rst), .clk_out(q[6]));
    hwlc_clkmon #(.P(20.0),  .H(10.0), .GRID(10.0), .OFS(5.0)) c2  (.q(q[0]), .en(men), .errs(e2),  .nrise(r2),  .msg(m2));
    hwlc_clkmon #(.P(30.0),  .H(10.0), .GRID(10.0), .OFS(5.0)) c3  (.q(q[1]), .en(men), .errs(e3),  .nrise(r3),  .msg(m3));
    hwlc_clkmon #(.P(40.0),  .H(20.0), .GRID(10.0), .OFS(5.0)) c4  (.q(q[2]), .en(men), .errs(e4),  .nrise(r4),  .msg(m4));
    hwlc_clkmon #(.P(50.0),  .H(20.0), .GRID(10.0), .OFS(5.0)) c5  (.q(q[3]), .en(men), .errs(e5),  .nrise(r5),  .msg(m5));
    hwlc_clkmon #(.P(70.0),  .H(30.0), .GRID(10.0), .OFS(5.0)) c7  (.q(q[4]), .en(men), .errs(e7),  .nrise(r7),  .msg(m7));
    hwlc_clkmon #(.P(80.0),  .H(40.0), .GRID(10.0), .OFS(5.0)) c8  (.q(q[5]), .en(men), .errs(e8),  .nrise(r8),  .msg(m8));
    hwlc_clkmon #(.P(160.0), .H(80.0), .GRID(10.0), .OFS(5.0)) c16 (.q(q[6]), .en(men), .errs(e16), .nrise(r16), .msg(m16));
    always #5 clk = ~clk;

    task report(input integer n, input integer e, input integer r, input [8*160-1:0] m, input [8*80-1:0] name);
        begin
            start_test;
            if (e != 0) `FAIL((detail, "N=%0d: %0s", n, m))
            else if (r < 640 / n - 1) `FAIL((detail, "N=%0d: only %0d rising edges of clk_out in 640 clock cycles", n, r))
            end_test(name);
        end
    endtask

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, d5); end
        start_test;
        repeat (2) @(posedge clk);
        for (k = 0; k < 40; k = k + 1) begin
            #1;
            if (q !== 7'd0) `FAIL((detail, "clk_out of the N=2..16 instances = %b at t=%.1f ns while rst is held", q, $realtime))
        end
        end_test("held low during reset");
        @(negedge clk) rst = 0;
        repeat (40) @(posedge clk);
        @(negedge clk) men = 1;
        repeat (640) @(posedge clk);
        #1 men = 0;
        report(2, e2, r2, m2, "N = 2");
        report(3, e3, r3, m3, "N = 3");
        report(4, e4, r4, m4, "N = 4");
        report(5, e5, r5, m5, "N = 5");
        report(7, e7, r7, m7, "N = 7");
        report(8, e8, r8, m8, "N = 8");
        report(16, e16, r16, m16, "N = 16");
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
