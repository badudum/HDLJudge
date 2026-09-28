`timescale 1ns/1ps
module tb;
    reg  clk = 0, rst = 1, din = 0;
    wire detected;
    reg  [3:0] hist;
    reg  m_det;
    integer i, errors, seed;
    reg [8*160-1:0] detail;
    reg [31:0] pattern;

    seq_detect dut (.clk(clk), .rst(rst), .din(din), .detected(detected));

    always #5 clk = ~clk;

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    task step(input r, input d);
        begin
            @(negedge clk);
            if (detected !== m_det) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t (last samples %b) expected detected=%b, got %b",
                             $time, hist, m_det, detected);
                errors = errors + 1;
            end
            rst = r; din = d;
            if (r) begin hist = 0; m_det = 0; end
            else begin hist = {hist[2:0], d}; m_det = (hist == 4'b1011); end
        end
    endtask

    task send(input [31:0] bits, input integer n);
        integer k;
        begin
            for (k = n - 1; k >= 0; k = k - 1) step(0, bits[k]);
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 5;
        @(negedge clk); @(negedge clk);
        hist = 0; m_det = 0;

        start_test;
        step(1, 0); send(32'b0000, 4); send(32'b0, 1);
        end_test("no detection after reset");

        start_test;
        send(32'b1011, 4); send(32'b00, 2);
        end_test("detects a single 1011");

        start_test;
        send(32'b1011011, 7); send(32'b00, 2);
        end_test("detects overlapping 1011011 twice");

        start_test;
        send(32'b1101011, 7); send(32'b00, 2);
        end_test("recovers after a partial match 11 -> 1011");

        start_test;
        send(32'b10101011, 8); send(32'b00, 2);
        end_test("recovers after 1010 -> 1011");

        start_test;
        send(32'b1111_0000_1001_0110, 16); send(32'b00, 2);
        end_test("rejects near misses");

        start_test;
        send(32'b101, 3); step(1, 1); send(32'b011, 3); send(32'b00, 2);
        end_test("reset discards a partial match");

        start_test;
        for (i = 0; i < 1000; i = i + 1) step(($random(seed) % 97) == 0, $random(seed) & 1);
        step(0, 0);
        end_test("1000 random bits");

        $display("TB_DONE");
        $finish;
    end

    initial begin
        #200000;
        $display("FAIL: testbench watchdog expired");
        $finish;
    end
endmodule
