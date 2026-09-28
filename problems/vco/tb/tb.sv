`timescale 1ns/1ps
module tb;
    real vctrl = 0.0;
    wire out1, out2;
    integer errors;
    reg [8*200-1:0] detail;
    real t0, t1, th, tl, period, f, want, duty;

    vco                             dut1 (.vctrl(vctrl), .clk_out(out1));
    vco #(.F0(20.0e6), .KVCO(10.0e6)) dut2 (.vctrl(vctrl), .clk_out(out2));

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    function real clampf(input real x);
        clampf = x < 1.0e6 ? 1.0e6 : (x > 1.0e9 ? 1.0e9 : x);
    endfunction

    task check(input integer which, input real v);
        integer k;
        reg [8*200-1:0] msg;
        begin
            vctrl = v;
            want = which == 1 ? clampf(100.0e6 + 50.0e6 * v) : clampf(20.0e6 + 10.0e6 * v);
            // settle for a few periods, then measure 20 periods and one high phase
            if (which == 1) begin
                repeat (3) @(posedge out1);
                t0 = $realtime;
                repeat (20) @(posedge out1);
                t1 = $realtime;
                th = $realtime; @(negedge out1); tl = $realtime;
            end else begin
                repeat (3) @(posedge out2);
                t0 = $realtime;
                repeat (20) @(posedge out2);
                t1 = $realtime;
                th = $realtime; @(negedge out2); tl = $realtime;
            end
            period = (t1 - t0) / 20.0;
            f = 1.0e9 / period;
            duty = (tl - th) / period;
            if (f < want * 0.995 || f > want * 1.005) begin
                $sformat(msg, "dut%0d vctrl=%.2f: expected %.4f MHz, measured %.4f MHz", which, v, want / 1e6, f / 1e6);
                if (errors == 0) detail = msg;
                errors = errors + 1;
            end else if (duty < 0.45 || duty > 0.55) begin
                $sformat(msg, "dut%0d vctrl=%.2f: duty cycle %.1f %% (expected 50 %%)", which, v, duty * 100.0);
                if (errors == 0) detail = msg;
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $timeformat(-9, 3, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut1, dut2);
        end
        #1;
        start_test;
        check(1, 0.0);
        end_test("centre frequency (vctrl = 0)");

        start_test;
        check(1, 1.0); check(1, -1.0); check(1, 0.37); check(1, 4.0);
        end_test("tuning curve f = F0 + KVCO * vctrl");

        start_test;
        check(1, -5.0); check(1, 25.0);
        end_test("clamping to 1 MHz ... 1 GHz");

        start_test;
        check(2, 0.0); check(2, 3.0); check(2, -1.5);
        end_test("parameters F0 and KVCO are honored");

        $display("TB_DONE");
        $finish;
    end

    initial begin
        #2000000;
        $display("FAIL: watchdog - clk_out stopped toggling");
        $finish;
    end
endmodule
