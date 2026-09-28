`timescale 1ns/1ps
module tb;
    logic       clk = 0;
    logic       rst = 1;
    logic       en  = 0;
    logic [3:0] count;
    logic [3:0] expected;

    counter dut (.clk(clk), .rst(rst), .en(en), .count(count));

    always #5 clk = ~clk;

    // apply inputs at the falling edge, update the model, check at the next falling edge
    task automatic step(input logic r, input logic e);
        @(negedge clk);
        if (count !== expected)
            $error("t=%0t: count=%0d, expected %0d", $time, count, expected);
        rst = r; en = e;
        if (r)      expected = 0;
        else if (e) expected = expected + 1;
    endtask

    initial begin
        @(negedge clk); @(negedge clk);
        expected = 0;
        step(1, 0); step(0, 0);
        repeat (20) step(0, 1);                    // count through the wrap-around
        repeat (3)  step(0, 0);                    // hold
        step(1, 1); step(0, 0);                    // reset has priority over enable
        repeat (5)  step(0, 1);
        // synchronous reset: no change between the clock edges
        @(negedge clk);
        if (count !== expected) $error("count=%0d, expected %0d", count, expected);
        rst = 1; en = 0; #2;
        if (count !== expected) $error("reset acted before the clock edge");
        @(negedge clk);
        if (count !== 0) $error("reset did not clear the count");
        rst = 0; expected = 0;
        for (int i = 0; i < 200; i++) step($urandom_range(0, 15) == 0, $urandom_range(0, 1));
        step(0, 0);
        $display("testbench finished");
        $finish;
    end

    initial begin
        #100000 $error("watchdog");
        $finish;
    end
endmodule
