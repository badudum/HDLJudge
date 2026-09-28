`timescale 1ns/1ps
module tb;
    reg        clk = 0;
    real       vin = 0.0;
    wire [7:0] code1, code2;
    reg  [7:0] m1, m2;
    integer    i, errors, seed;
    reg [8*200-1:0] detail;

    adc8               dut1 (.clk(clk), .vin(vin), .code(code1));
    adc8 #(.VREF(2.0)) dut2 (.clk(clk), .vin(vin), .code(code2));

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

    function [7:0] quant(input real v, input real vref);
        real x;
        begin
            x = $floor(v / vref * 256.0);
            if (x < 0.0) quant = 0;
            else if (x > 255.0) quant = 255;
            else quant = $rtoi(x);
        end
    endfunction

    task check;
        begin
            if (code1 !== m1 || code2 !== m2) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t: expected code=%0d (VREF=1) / %0d (VREF=2), got %0d / %0d",
                             $time, m1, m2, code1, code2);
                errors = errors + 1;
            end
        end
    endtask

    // apply vin at the falling edge; check the sampled result at the next falling edge
    task sample(input real v);
        begin
            vin = v;
            @(negedge clk);
            m1 = quant(v, 1.0);
            m2 = quant(v, 2.0);
            check;
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut1, dut2);
        end
        seed = 23;
        m1 = 0; m2 = 0;
        #2;
        start_test;
        check;
        end_test("code is 0 before the first clock edge");
        @(negedge clk);

        start_test;
        sample(0.0); sample(0.00390625); sample(0.0039); sample(0.25); sample(0.5); sample(0.75);
        end_test("exact code transitions");

        start_test;
        sample(-0.2); sample(-5.0); sample(0.999); sample(1.0); sample(1.3); sample(3.9); sample(4.5);
        end_test("clamps to 0 and 255");

        start_test;
        vin = 0.5;
        @(negedge clk);
        m1 = 128; m2 = 64;
        vin = 0.9; #1; check;
        vin = 0.1; #3; check;
        @(negedge clk);
        m1 = quant(0.1, 1.0); m2 = quant(0.1, 2.0); check;
        end_test("output only changes on the rising clock edge");

        start_test;
        for (i = 0; i < 900; i = i + 1) sample(-0.05 + i * 0.00131);
        end_test("ramp from -0.05 V to 1.13 V (900 samples)");

        start_test;
        for (i = 0; i < 500; i = i + 1) sample(1.0 + 1.1 * $sin(6.2831853 * i / 97.0));
        end_test("sine input, VREF 1.0 and 2.0 (500 samples)");

        $display("TB_DONE");
        $finish;
    end
endmodule
