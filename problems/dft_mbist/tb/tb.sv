`timescale 1ns/1ps
module tb;
    reg        clk = 0, rst = 1, start = 0;
    wire [3:0] mem_addr, mem_wdata, mem_rdata;
    wire       mem_we, busy, done, fail;
    reg  [3:0] mem [0:15];
    integer    fault, errors, i, cycles, seed;
    reg [8*200-1:0] detail;

    mbist dut (.clk(clk), .rst(rst), .start(start), .mem_rdata(mem_rdata),
               .mem_addr(mem_addr), .mem_we(mem_we), .mem_wdata(mem_wdata),
               .busy(busy), .done(done), .fail(fail));

    always #5 clk = ~clk;

    // ------------------------------------------------ memory model with injectable faults
    // 0 none, 1 SA0 word5 bit2, 2 SA1 word9 bit0, 3 inversion coupling (write 3 flips word12 bit1),
    // 4 address decoder (7 aliases to 6), 5 transition fault (word2 bit3 cannot rise)
    wire [3:0] raddr = (fault == 4 && mem_addr == 4'd7) ? 4'd6 : mem_addr;
    wire [3:0] rword = mem[raddr];
    assign mem_rdata = (fault == 1 && raddr == 4'd5) ? (rword & 4'b1011) :
                       (fault == 2 && raddr == 4'd9) ? (rword | 4'b0001) : rword;

    reg [3:0] wa, wv;
    always @(posedge clk) begin
        if (mem_we) begin
            wa = (fault == 4 && mem_addr == 4'd7) ? 4'd6 : mem_addr;
            wv = mem_wdata;
            if (fault == 5 && wa == 4'd2 && mem[2][3] == 1'b0) wv[3] = 1'b0;
            mem[wa] <= wv;
            if (fault == 3 && wa == 4'd3) mem[12][1] <= ~mem[12][1];
        end
    end

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    task run_chip(input integer f, input expect_fail);
        reg [8*200-1:0] msg;
        begin
            fault = f;
            for (i = 0; i < 16; i = i + 1) mem[i] = $random(seed);
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            cycles = 1;
            while (done !== 1'b1 && cycles < 2000) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (done !== 1'b1) begin
                $sformat(msg, "fault model %0d: no done pulse within 2000 cycles", f);
                if (errors == 0) detail = msg;
                errors = errors + 1;
            end else if (fail !== expect_fail) begin
                $sformat(msg, "fault model %0d: expected fail=%0d, got %b", f, expect_fail, fail);
                if (errors == 0) detail = msg;
                errors = errors + 1;
            end
            @(negedge clk);
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 82;
        fault = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;

        start_test; run_chip(0, 0); end_test("good memory passes");
        start_test; run_chip(1, 1); run_chip(2, 1); end_test("stuck-at faults are detected");
        start_test; run_chip(5, 1); end_test("transition fault is detected");
        start_test; run_chip(3, 1); end_test("coupling fault is detected");
        start_test; run_chip(4, 1); end_test("address decoder fault is detected");
        start_test; run_chip(0, 0); end_test("fail is cleared by the next start");

        $display("TB_DONE");
        $finish;
    end
endmodule
