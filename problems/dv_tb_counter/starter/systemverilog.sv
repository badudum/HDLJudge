`timescale 1ns/1ps
module tb;
    logic       clk = 0;
    logic       rst = 1;
    logic       en  = 0;
    logic [3:0] count;

    counter dut (.clk(clk), .rst(rst), .en(en), .count(count));

    always #5 clk = ~clk;

    initial begin
        // Drive stimulus, predict the expected count, compare,
        // and call $error("...") when the design misbehaves.

        $finish;
    end
endmodule
