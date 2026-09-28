`timescale 1ns/1ps
module tb;
    reg        clk = 0, rst = 1, en = 0;
    wire [3:0] count;
    reg  [3:0] model;
    integer    i, errors, seed;
    reg [8*160-1:0] detail;

    counter dut (.clk(clk), .rst(rst), .en(en), .count(count));

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

    // compare at the falling edge, then apply new inputs and advance the model
    task step(input r, input e);
        begin
            @(negedge clk);
            if (count !== model) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t expected count=%0d, got %0d", $time, model, count);
                errors = errors + 1;
            end
            rst = r; en = e;
            if (r) model = 0; else if (e) model = model + 1;
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 11;
        @(negedge clk); @(negedge clk);
        model = 0;

        start_test;
        step(1, 1); step(0, 0); step(0, 0);
        end_test("reset clears the counter");

        start_test;
        for (i = 0; i < 20; i = i + 1) step(0, 1);
        step(0, 0);
        end_test("counts up and wraps from 15 to 0");

        start_test;
        for (i = 0; i < 6; i = i + 1) step(0, 0);
        end_test("holds its value when en=0");

        start_test;
        step(1, 1); step(0, 0);
        end_test("reset has priority over enable");

        // synchronous reset: count must not change between clock edges
        start_test;
        for (i = 0; i < 5; i = i + 1) step(0, 1);
        @(negedge clk);
        model = count;
        rst = 1; #2;
        if (count !== model) begin
            errors = errors + 1;
            $sformat(detail, "count changed from %0d to %0d before the clock edge", model, count);
        end
        @(posedge clk); #1;
        if (count !== 0) begin
            if (errors == 0) $sformat(detail, "count is %0d after the reset edge", count);
            errors = errors + 1;
        end
        model = 0;
        end_test("reset is synchronous");

        start_test;
        for (i = 0; i < 300; i = i + 1) step(($random(seed) & 15) == 0, $random(seed) & 1);
        step(0, 0);
        end_test("300 random cycles of en/rst");

        $display("TB_DONE");
        $finish;
    end

    initial begin
        #100000;
        $display("FAIL: testbench watchdog expired");
        $finish;
    end
endmodule
