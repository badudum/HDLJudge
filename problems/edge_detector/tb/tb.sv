`timescale 1ns/1ps
module tb;
    reg  clk = 0, rst = 1, din = 0;
    wire pulse;
    reg  m_prev, m_pulse;
    integer i, errors, seed;
    reg [8*160-1:0] detail;

    edge_detect dut (.clk(clk), .rst(rst), .din(din), .pulse(pulse));

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
            if (pulse !== m_pulse) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t expected pulse=%b, got %b", $time, m_pulse, pulse);
                errors = errors + 1;
            end
            rst = r; din = d;
            if (r) begin m_prev = 0; m_pulse = 0; end
            else begin m_pulse = d & ~m_prev; m_prev = d; end
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 3;
        @(negedge clk); @(negedge clk);
        m_prev = 0; m_pulse = 0;

        start_test;
        step(1, 0); step(0, 0); step(0, 0);
        end_test("pulse is low after reset");

        start_test;
        step(0, 1); step(0, 1); step(0, 1); step(0, 1); step(0, 0); step(0, 0);
        end_test("single one-cycle pulse on a long high input");

        start_test;
        for (i = 0; i < 10; i = i + 1) step(0, i & 1);
        step(0, 0);
        end_test("alternating input 0101...");

        start_test;
        step(0, 0); step(0, 0); step(0, 0); step(0, 0);
        end_test("no pulse while input is low");

        start_test;
        step(0, 1); step(1, 1); step(0, 1); step(0, 1); step(0, 0);
        end_test("reset clears the stored sample");

        start_test;
        for (i = 0; i < 400; i = i + 1) step(($random(seed) & 31) == 0, $random(seed) & 1);
        step(0, 0);
        end_test("400 random cycles");

        $display("TB_DONE");
        $finish;
    end

    initial begin
        #100000;
        $display("FAIL: testbench watchdog expired");
        $finish;
    end
endmodule
