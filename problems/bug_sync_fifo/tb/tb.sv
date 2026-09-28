`timescale 1ns/1ps
module tb;
    reg        clk = 0, rst = 1, wr_en = 0, rd_en = 0;
    reg  [7:0] din = 0;
    wire [7:0] dout;
    wire       full, empty;
    wire [3:0] count;

    // reference model
    reg  [7:0] q [0:7];
    integer    q_head, q_cnt;
    reg  [7:0] m_dout;

    integer i, errors, seed;
    reg [8*200-1:0] detail;

    sync_fifo dut (.clk(clk), .rst(rst), .wr_en(wr_en), .din(din), .rd_en(rd_en),
                   .dout(dout), .full(full), .empty(empty), .count(count));

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

    task step(input r, input w, input [7:0] d, input rd);
        reg do_w, do_r;
        begin
            @(negedge clk);
            if (count !== q_cnt[3:0] || full !== (q_cnt == 8) || empty !== (q_cnt == 0)
                || dout !== m_dout) begin
                if (errors == 0)
                    $sformat(detail, "at t=%t expected count=%0d full=%b empty=%b dout=%h, got count=%0d full=%b empty=%b dout=%h",
                             $time, q_cnt, q_cnt == 8, q_cnt == 0, m_dout, count, full, empty, dout);
                errors = errors + 1;
            end
            rst = r; wr_en = w; din = d; rd_en = rd;
            if (r) begin
                q_head = 0; q_cnt = 0; m_dout = 0;
            end else begin
                do_w = w && q_cnt < 8;
                do_r = rd && q_cnt > 0;
                if (do_r) begin
                    m_dout = q[q_head];
                    q_head = (q_head + 1) % 8;
                    q_cnt = q_cnt - 1;
                end
                if (do_w) begin
                    q[(q_head + q_cnt) % 8] = d;
                    q_cnt = q_cnt + 1;
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
        seed = 17;
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        q_head = 0; q_cnt = 0; m_dout = 0;

        start_test;
        step(1, 0, 0, 0); step(0, 0, 0, 0);
        end_test("empty after reset");

        start_test;
        for (i = 0; i < 8; i = i + 1) step(0, 1, 8'hA0 + i, 0);
        step(0, 0, 0, 0);
        end_test("fills up to 8 entries and asserts full");

        start_test;
        step(0, 1, 8'hEE, 0); step(0, 1, 8'hEF, 0); step(0, 0, 0, 0);
        end_test("writes while full are ignored");

        start_test;
        for (i = 0; i < 8; i = i + 1) step(0, 0, 0, 1);
        step(0, 0, 0, 0);
        end_test("reads back in FIFO order and asserts empty");

        start_test;
        step(0, 0, 0, 1); step(0, 0, 0, 1); step(0, 0, 0, 0);
        end_test("reads while empty are ignored (dout holds)");

        start_test;
        step(0, 1, 8'h11, 1); step(0, 1, 8'h22, 1); step(0, 1, 8'h33, 1);
        step(0, 0, 0, 1); step(0, 0, 0, 0);
        end_test("simultaneous read and write");

        start_test;
        for (i = 0; i < 8; i = i + 1) step(0, 1, i * 3, 0);
        for (i = 0; i < 4; i = i + 1) step(0, 1, 8'h50 + i, 1);
        step(0, 0, 0, 0);
        end_test("read+write while full performs only the read");

        start_test;
        step(1, 1, 8'h99, 1); step(0, 0, 0, 0);
        end_test("reset empties the FIFO");

        start_test;
        for (i = 0; i < 2000; i = i + 1)
            if (i[7] == 0)   // alternate mostly-filling and mostly-draining phases
                step(($random(seed) % 211) == 0, ($random(seed) & 3) != 0,
                     $random(seed), ($random(seed) & 7) < 3);
            else
                step(($random(seed) % 211) == 0, ($random(seed) & 7) < 3,
                     $random(seed), ($random(seed) & 3) != 0);
        step(0, 0, 0, 0);
        end_test("2000 random cycles");

        $display("TB_DONE");
        $finish;
    end

    initial begin
        #500000;
        $display("FAIL: testbench watchdog expired");
        $finish;
    end
endmodule
