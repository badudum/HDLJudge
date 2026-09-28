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

    wire gclk;

    reg  clk = 0, chk = 0;
    reg  en = 1'bx, te = 1'bx;
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

    icg dut (.clk(clk), .en(en), .test_en(te), .gclk(gclk));
    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        #1 en = 0; te = 0;
        @(negedge clk); #1; chk = 1;

        start_test;
        en = 1; repeat (10) @(posedge clk);
        @(negedge clk); #1;
        end_test("passes the clock when enabled");

        start_test;
        en = 0; repeat (10) @(posedge clk);
        @(negedge clk); #1;
        end_test("blocks the clock when disabled");

        start_test;
        for (k = 0; k < 40; k = k + 1) begin
            @(posedge clk); #(0.5 + 0.5 * ($random & 7)); en = ~en;
        end
        @(negedge clk); #1;
        end_test("enable changes while clk is high");

        start_test;
        for (k = 0; k < 40; k = k + 1) begin
            @(negedge clk); #(0.5 + 0.5 * ($random & 7)); en = ~en;
        end
        @(negedge clk); #1;
        end_test("enable changes while clk is low");

        start_test;
        en = 0; te = 1; repeat (6) @(posedge clk);
        #2.5 te = 0; repeat (4) @(posedge clk);
        #1.5 te = 1; en = 1; repeat (3) @(posedge clk);
        @(negedge clk); te = 0; en = 0; #1;
        repeat (3) @(posedge clk);
        end_test("test_en forces the clock on");

        start_test;
        for (k = 0; k < 1500; k = k + 1) begin
            n = $random & 31;
            #(0.5 * n + 0.5);
            if ($random & 1) en = ~en; else te = (($random & 7) == 0);
        end
        te = 0;
        #20;
        end_test("1500 random enable changes at arbitrary times");
        $display("TB_DONE");
        $finish;
    end
endmodule
