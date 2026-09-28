`timescale 1ns/1ps
`define FAIL(args) begin if (errors == 0) $sformat args ; errors = errors + 1; end
module tb;
    integer errors;
    reg [8*240-1:0] detail;
    task start_test; begin errors = 0; detail = ""; end endtask
    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d errors)", name, detail, errors);
        end
    endtask

    reg go = 0;
    reg [1:0] mode = 0;
    integer e1, s1, r1, e2, s2, r2, p1, p2;
    wire [8*200-1:0] m1, m2;
    hwlc_hs_env #(.PA(7.0),  .PB(23.0), .OA(0.0), .OB(1.3), .SEED(11)) fast_slow (.go(go), .mode(mode), .errs(e1), .ns(s1), .nr(r1), .msg(m1));
    hwlc_hs_env #(.PA(23.0), .PB(6.0),  .OA(0.7), .OB(0.0), .SEED(22)) slow_fast (.go(go), .mode(mode), .errs(e2), .ns(s2), .nr(r2), .msg(m2));

    task check_env(input integer e, input integer s, input integer r, input integer s0, input [8*200-1:0] m, input integer min_words);
        begin
            if (e != 0) `FAIL((detail, "%0s", m))
            else if (r != s) `FAIL((detail, "%0d words accepted but %0d delivered after draining", s, r))
            else if (s - s0 < min_words) `FAIL((detail, "only %0d words transferred in 20 us (a_ready stuck low?)", s - s0))
        end
    endtask

    initial begin
        #1 go = 1;
        #300;
        start_test;
        p1 = s1; mode = 2; #20000; mode = 0; #2000;
        check_env(e1, s1, r1, p1, m1, 40);
        end_test("fast to slow, full rate");

        start_test;
        p2 = s2; mode = 2; #20000; mode = 0; #2000;
        check_env(e2, s2, r2, p2 - (s2 - p2 >= 0 ? 0 : 0), m2, 40);
        end_test("slow to fast, full rate");

        start_test;
        p1 = s1; p2 = s2; mode = 1; #60000; mode = 0; #3000;
        check_env(e1, s1, r1, p1, m1, 20);
        check_env(e2, s2, r2, p2, m2, 20);
        end_test("random valid, both directions");
        $display("TB_DONE");
        $finish;
    end
endmodule

// Drives one DUT with random valid/data on the A side and scoreboards the B side.
module hwlc_hs_env #(parameter real PA = 7.0, parameter real PB = 23.0, parameter real OA = 0.0, parameter real OB = 1.3, parameter SEED = 1)
                    (input wire go, input wire [1:0] mode,
                     output integer errs, output integer ns, output integer nr, output reg [8*200-1:0] msg);
    reg  ca = 0, cb = 0, rst_a = 1, rst_b = 1, a_valid = 0, acc;
    reg  [7:0] a_data = 0;
    wire a_ready, b_valid;
    wire [7:0] b_data;
    reg  [7:0] sent [0:4095];
    integer tcap [0:4095];
    integer nb, seed;

    cdc_handshake dut (.clk_a(ca), .rst_a(rst_a), .a_valid(a_valid), .a_data(a_data), .a_ready(a_ready),
                       .clk_b(cb), .rst_b(rst_b), .b_valid(b_valid), .b_data(b_data));

    initial begin #(OA); forever begin ca = 1; #(PA / 2); ca = 0; #(PA / 2); end end
    initial begin #(OB); forever begin cb = 1; #(PB / 2); cb = 0; #(PB / 2); end end
    initial begin errs = 0; ns = 0; nr = 0; nb = 0; msg = ""; seed = SEED; end
    always @(posedge go) begin
        repeat (6) @(negedge ca); rst_a = 0;
    end
    always @(posedge go) begin
        repeat (6) @(negedge cb); rst_b = 0;
    end

    always @(posedge cb) nb = nb + 1;
    always @(posedge ca) begin
        acc = !rst_a && a_valid && a_ready;
        if (acc) begin
            sent[ns % 4096] = a_data; tcap[ns % 4096] = nb; ns = ns + 1;
        end
    end
    always @(negedge ca) if (!a_valid || acc) begin
        a_valid = (mode == 2) || (mode == 1 && ($random(seed) & 1));
        a_data  = $random(seed);
    end
    always @(posedge cb) if (!rst_b && b_valid === 1'b1) begin
        if (nr >= ns) begin
            if (errs == 0) $sformat(msg, "b_valid at t=%.1f ns but only %0d words were accepted on the A side (duplicate or phantom transfer)", $realtime, ns);
            errs = errs + 1;
        end else begin
            if (b_data !== sent[nr % 4096]) begin
                if (errs == 0) $sformat(msg, "word #%0d: b_data = 0x%02h, expected 0x%02h", nr, b_data, sent[nr % 4096]);
                errs = errs + 1;
            end
            if (nb - tcap[nr % 4096] < 3) begin
                if (errs == 0) $sformat(msg, "word #%0d arrived only %0d clk_b edges after capture: it was not synchronized through 2 flops", nr, nb - tcap[nr % 4096]);
                errs = errs + 1;
            end
            if (nb - tcap[nr % 4096] > 10) begin
                if (errs == 0) $sformat(msg, "word #%0d took %0d clk_b edges to arrive (limit 10)", nr, nb - tcap[nr % 4096]);
                errs = errs + 1;
            end
        end
        nr = nr + 1;
    end
endmodule
