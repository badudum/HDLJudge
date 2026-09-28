`timescale 1ns/1ps
module tb;
    reg   clk = 0;
    real  vin = 0.0;
    real  vout1, vout2;
    real  m1, m2, a1, a2, err;
    integer i, errors;
    reg [8*200-1:0] detail;

    rc_lpf                  dut1 (.clk(clk), .vin(vin), .vout(vout1));
    rc_lpf #(.TAU(200e-9))  dut2 (.clk(clk), .vin(vin), .vout(vout2));

    always #5 clk = ~clk;   // TS = 10 ns

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    function real absr(input real x);
        absr = x < 0.0 ? -x : x;
    endfunction

    task check;
        begin
            if (!(absr(vout1 - m1) <= 1e-9) || !(absr(vout2 - m2) <= 1e-9)) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t: expected vout=%.9f (TAU=1us) / %.9f (TAU=200ns), got %.9f / %.9f",
                             $time, m1, m2, vout1, vout2);
                errors = errors + 1;
            end
        end
    endtask

    // drive vin for n clock cycles, checking after every edge
    task drive(input real v, input integer n);
        integer k;
        begin
            vin = v;
            for (k = 0; k < n; k = k + 1) begin
                @(negedge clk);
                m1 = m1 + (v - m1) * a1;
                m2 = m2 + (v - m2) * a2;
                check;
            end
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut1, dut2);
        end
        a1 = 1.0 - $exp(-10e-9 / 1e-6);
        a2 = 1.0 - $exp(-10e-9 / 200e-9);
        m1 = 0.0; m2 = 0.0;
        #2;
        start_test;
        check;
        end_test("vout starts at 0.0");
        @(negedge clk);

        start_test;
        drive(0.0, 5);
        end_test("stays at 0 with zero input");

        start_test;
        drive(1.0, 100);
        end_test("unit step response matches the recurrence");

        start_test;
        err = absr(vout1 - (1.0 - $exp(-1.0)));
        if (!(err < 0.005)) begin
            errors = 1;
            $sformat(detail, "after one TAU expected about 0.632, got %.4f", vout1);
        end
        end_test("reaches 63.2% after one time constant");

        start_test;
        drive(1.0, 300);
        drive(-0.5, 400);
        end_test("settles and discharges toward a new level");

        start_test;
        for (i = 0; i < 1000; i = i + 1)
            drive($sin(6.2831853 * i / 250.0) + 0.3 * $sin(6.2831853 * i / 9.0), 1);
        end_test("filters a two-tone input (1000 steps)");

        $display("TB_DONE");
        $finish;
    end
endmodule
