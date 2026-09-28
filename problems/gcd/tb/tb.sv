`timescale 1ns/1ps
module tb;
    reg         clk = 0, rst = 1, start = 0;
    reg  [15:0] a = 0, b = 0;
    wire        busy, done;
    wire [15:0] result;
    integer     errors, cycles, i, seed;
    reg [8*200-1:0] detail;

    gcd16 dut (.clk(clk), .rst(rst), .start(start), .a(a), .b(b),
               .busy(busy), .done(done), .result(result));

    always #5 clk = ~clk;

    function [15:0] gold(input [15:0] x, input [15:0] y);
        reg [15:0] t;
        begin
            while (y != 0) begin
                t = x % y;
                x = y;
                y = t;
            end
            gold = x;
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

    // issue one request and wait for done; second_x/y != 0 injects a start while busy
    task run(input [15:0] x, input [15:0] y, input inject);
        reg [15:0] want;
        reg [8*200-1:0] msg;
        begin
            want = gold(x, y);
            @(negedge clk);
            a = x; b = y; start = 1;
            @(negedge clk);
            start = 0; a = $random(seed); b = $random(seed);   // operands must have been latched
            cycles = 1;
            if (done !== 1'b1 && busy !== 1'b1) begin
                $sformat(msg, "gcd(%0d, %0d): busy must be 1 while computing", x, y);
                fail(msg);
            end
            if (inject && done !== 1'b1) begin
                a = 16'd12; b = 16'd8; start = 1;          // must be ignored
                @(negedge clk); start = 0; cycles = cycles + 1;
            end
            while (done !== 1'b1 && cycles < 140000) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (done !== 1'b1) begin
                $sformat(msg, "gcd(%0d, %0d): no done pulse within 140000 cycles", x, y);
                fail(msg);
            end else begin
                if (result !== want) begin
                    $sformat(msg, "gcd(%0d, %0d): expected %0d, got %0d", x, y, want, result);
                    fail(msg);
                end
                if (busy !== 1'b0) begin
                    $sformat(msg, "gcd(%0d, %0d): busy must be 0 in the done cycle", x, y);
                    fail(msg);
                end
                @(negedge clk);
                if (done !== 1'b0) begin
                    $sformat(msg, "gcd(%0d, %0d): done must be a one-cycle pulse", x, y);
                    fail(msg);
                end
                if (result !== want) begin
                    $sformat(msg, "gcd(%0d, %0d): result must hold after done", x, y);
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
        seed = 34;
        @(negedge clk); @(negedge clk);
        rst = 0;

        start_test;
        run(48, 18, 0); run(18, 48, 0); run(7, 21, 0); run(100, 75, 0); run(1, 1, 0);
        end_test("small pairs");

        start_test;
        run(0, 25, 0); run(25, 0, 0); run(0, 0, 0); run(1234, 1234, 0);
        end_test("zero and equal operands");

        start_test;
        run(65521, 65519, 0); run(1024, 243, 0); run(40000, 39999, 0);
        end_test("coprime pairs");

        start_test;
        run(65535, 1, 0); run(1, 65535, 0);
        end_test("lopsided operands (65535, 1)");

        start_test;
        run(3000, 1, 1);
        end_test("start is ignored while busy");

        start_test;
        for (i = 0; i < 40; i = i + 1) run($random(seed), $random(seed), 0);
        end_test("40 random pairs");

        $display("TB_DONE");
        $finish;
    end
endmodule
