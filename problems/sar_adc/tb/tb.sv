`timescale 1ns/1ps
module tb;
    reg        clk = 0, rst = 1, start = 0;
    real       vin = 0.0;
    reg        cmp;
    wire [7:0] dac, result;
    wire       done;
    integer    errors, cycles, i, seed;
    reg [8*200-1:0] detail;

    sar_ctrl dut (.clk(clk), .rst(rst), .start(start), .cmp(cmp),
                  .dac(dac), .done(done), .result(result));

    always #5 clk = ~clk;

    // analog model: ideal 8-bit DAC (VREF = 1.0) + comparator
    always @(*) cmp = (vin >= dac / 256.0);

    function [7:0] gold(input real v);
        real x;
        begin
            x = $floor(v * 256.0);
            if (x < 0.0) gold = 0;
            else if (x > 255.0) gold = 255;
            else gold = $rtoi(x);
        end
    endfunction

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    task fail(input [8*200-1:0] msg);
        begin
            if (errors == 0) detail = msg;
            errors = errors + 1;
        end
    endtask

    task convert(input real v, input inject);
        reg [8*200-1:0] msg;
        begin
            @(negedge clk);
            vin = v; start = 1;
            @(negedge clk);
            start = 0;
            cycles = 1;
            if (inject && done !== 1'b1) begin
                start = 1; @(negedge clk); start = 0; cycles = cycles + 1;
            end
            while (done !== 1'b1 && cycles < 40) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (done !== 1'b1) begin
                $sformat(msg, "vin=%.5f: no done pulse within 40 cycles", v);
                fail(msg);
            end else begin
                if (result !== gold(v)) begin
                    $sformat(msg, "vin=%.5f: expected result=%0d, got %0d", v, gold(v), result);
                    fail(msg);
                end
                @(negedge clk);
                if (done !== 1'b0) begin
                    $sformat(msg, "vin=%.5f: done must be a one-cycle pulse", v);
                    fail(msg);
                end
                if (result !== gold(v)) begin
                    $sformat(msg, "vin=%.5f: result must hold after done", v);
                    fail(msg);
                end
            end
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 35;
        @(negedge clk); @(negedge clk);
        rst = 0;

        start_test;
        convert(0.5, 0); convert(0.0, 0); convert(0.99609375, 0); convert(0.25, 0); convert(0.75, 0);
        end_test("mid-scale and full-scale");

        start_test;
        convert(-0.3, 0); convert(1.3, 0); convert(1.0, 0);
        end_test("clamps below 0 and above VREF");

        start_test;
        convert(0.3, 1);
        end_test("start ignored during a conversion");

        start_test;
        for (i = 0; i < 512; i = i + 1) convert(i / 512.0, 0);
        end_test("every code, on and between thresholds (512 conversions)");

        start_test;
        for (i = 0; i < 200; i = i + 1) convert(($random(seed) & 32'hFFFF) / 65536.0 * 1.1 - 0.05, 0);
        end_test("200 random input voltages");

        $display("TB_DONE");
        $finish;
    end
endmodule
