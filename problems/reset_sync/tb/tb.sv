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

    reg  clk = 0, ck = 1, arst_n = 0;
    wire rst_n;
    integer k;
    reset_sync dut (.clk(clk), .arst_n(arst_n), .rst_n(rst_n));
    always #5 if (ck) clk = ~clk; else clk = 1'b0;

    task release_and_check(input real ofs);
        begin
            @(posedge clk); #(ofs); arst_n = 1;
            #0.2 if (rst_n !== 1'b0) `FAIL((detail, "rst_n = %b right after arst_n rose (must wait for the clock)", rst_n))
            @(posedge clk); #1;
            if (rst_n !== 1'b0) `FAIL((detail, "rst_n = %b after the 1st rising edge following release (expected 0)", rst_n))
            @(posedge clk); #1;
            if (rst_n !== 1'b1) `FAIL((detail, "rst_n = %b after the 2nd rising edge following release (expected 1)", rst_n))
            repeat (3) @(posedge clk);
            #1 if (rst_n !== 1'b1) `FAIL((detail, "rst_n dropped again without a reset"))
        end
    endtask

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        start_test;
        repeat (3) @(posedge clk);
        #1 if (rst_n !== 1'b0) `FAIL((detail, "rst_n = %b while arst_n = 0", rst_n))
        end_test("held in reset while arst_n = 0");

        start_test;
        release_and_check(2.0);
        @(negedge clk); arst_n = 0; #1;
        release_and_check(7.5);
        @(negedge clk); arst_n = 0; #1;
        release_and_check(0.5);
        end_test("deasserts on the second rising edge");

        start_test;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge clk); #(1.3 + 0.7 * k); arst_n = 0;
            #0.3 if (rst_n !== 1'b0) `FAIL((detail, "rst_n = %b 0.3 ns after arst_n fell mid-cycle (expected 0 immediately)", rst_n))
            #4 arst_n = 1;
            repeat (3) @(posedge clk);
        end
        end_test("asserts asynchronously (clock running)");

        start_test;
        @(negedge clk); ck = 0; #20;
        arst_n = 0; #0.3;
        if (rst_n !== 1'b0) `FAIL((detail, "rst_n = %b with the clock stopped (expected immediate assertion)", rst_n))
        #10 arst_n = 1; #50;
        if (rst_n !== 1'b0) `FAIL((detail, "rst_n released without any clock edge"))
        ck = 1;
        @(posedge clk); #1;
        if (rst_n !== 1'b0) `FAIL((detail, "rst_n released at the first clock edge after restart"))
        @(posedge clk); #1;
        if (rst_n !== 1'b1) `FAIL((detail, "rst_n not released at the second clock edge after restart"))
        end_test("asserts asynchronously (clock stopped)");

        start_test;
        @(posedge clk); #3; arst_n = 0; #1 arst_n = 1;
        #0.2 if (rst_n !== 1'b0) `FAIL((detail, "a 1 ns pulse on arst_n did not assert rst_n"))
        @(posedge clk); #1 if (rst_n !== 1'b0) `FAIL((detail, "rst_n released one edge after a short reset pulse"))
        @(posedge clk); #1 if (rst_n !== 1'b1) `FAIL((detail, "rst_n not released two edges after a short reset pulse"))
        end_test("short reset pulse");
        $display("TB_DONE");
        $finish;
    end
endmodule
