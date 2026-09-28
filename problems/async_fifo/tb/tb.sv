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
    reg [1:0] wm = 0, rm = 0;
    integer e1, w1, r1, e2, w2, r2;
    wire f1, em1, f2, em2;
    wire [8*200-1:0] m1, m2;
    hwlc_fifo_env #(.WP(10.0), .RP(17.0), .WO(0.0), .RO(2.3), .SEED(5)) wfast (.go(go), .wmode(wm), .rmode(rm), .errs(e1), .wn(w1), .rn(r1), .wfull(f1), .rempty(em1), .msg(m1));
    hwlc_fifo_env #(.WP(23.0), .RP(6.0),  .WO(1.1), .RO(0.4), .SEED(9)) rfast (.go(go), .wmode(wm), .rmode(rm), .errs(e2), .wn(w2), .rn(r2), .wfull(f2), .rempty(em2), .msg(m2));

    task errs_both;
        begin
            if (e1 != 0) `FAIL((detail, "fast writer / slow reader: %0s", m1))
            if (e2 != 0) `FAIL((detail, "slow writer / fast reader: %0s", m2))
        end
    endtask

    initial begin
        #1 go = 1;
        #400;
        start_test;
        if (em1 !== 1'b1 || em2 !== 1'b1 || f1 !== 1'b0 || f2 !== 1'b0) `FAIL((detail, "after reset expected rempty = 1, wfull = 0 (got rempty %b/%b, wfull %b/%b)", em1, em2, f1, f2))
        end_test("empty after reset");

        start_test;
        wm = 2; rm = 0; #1500; wm = 0; #300;
        errs_both;
        if (w1 - r1 != 8 || f1 !== 1'b1) `FAIL((detail, "fast writer: %0d entries accepted with the reader idle, wfull = %b (expected 8 and 1)", w1 - r1, f1))
        if (w2 - r2 != 8 || f2 !== 1'b1) `FAIL((detail, "slow writer: %0d entries accepted with the reader idle, wfull = %b (expected 8 and 1)", w2 - r2, f2))
        end_test("accepts exactly 8 writes");

        start_test;
        rm = 2; #1500; rm = 0; #300;
        errs_both;
        if (r1 != w1 || em1 !== 1'b1 || f1 !== 1'b0) `FAIL((detail, "fast writer: %0d of %0d entries read, rempty = %b, wfull = %b", r1, w1, em1, f1))
        if (r2 != w2 || em2 !== 1'b1 || f2 !== 1'b0) `FAIL((detail, "slow writer: %0d of %0d entries read, rempty = %b, wfull = %b", r2, w2, em2, f2))
        end_test("drains all entries in order");

        start_test;
        wm = 1; rm = 1; #30000;
        wm = 0; #1000; rm = 2; #1500; rm = 0;
        errs_both;
        if (r1 != w1) `FAIL((detail, "fast writer: %0d written but %0d read after draining", w1, r1))
        if (r2 != w2) `FAIL((detail, "slow writer: %0d written but %0d read after draining", w2, r2))
        if (w1 < 500 || w2 < 300) `FAIL((detail, "too little traffic got through (%0d / %0d words): flags stuck?", w1, w2))
        end_test("random traffic, fast writer and fast reader");

        start_test;
        wm = 2; rm = 1; #20000;
        wm = 0; #1000; rm = 2; #2000; rm = 0;
        errs_both;
        if (r1 != w1 || r2 != w2) `FAIL((detail, "entries lost: %0d/%0d and %0d/%0d", r1, w1, r2, w2))
        end_test("sustained writes with a slow reader");
        $display("TB_DONE");
        $finish;
    end
endmodule

module hwlc_fifo_env #(parameter real WP = 10.0, parameter real RP = 17.0, parameter real WO = 0.0, parameter real RO = 2.3, parameter SEED = 1)
                      (input wire go, input wire [1:0] wmode, input wire [1:0] rmode,
                       output integer errs, output integer wn, output integer rn, output wire wfull, output wire rempty,
                       output reg [8*200-1:0] msg);
    reg  wclk = 0, rclk = 0, wrst = 1, rrst = 1, winc = 0, rinc = 0;
    reg  [7:0] wdata = 0;
    wire [7:0] rdata;
    reg  [7:0] q [0:1023];
    integer seed;

    async_fifo dut (.wclk(wclk), .wrst(wrst), .winc(winc), .wdata(wdata), .wfull(wfull),
                    .rclk(rclk), .rrst(rrst), .rinc(rinc), .rdata(rdata), .rempty(rempty));

    initial begin #(WO); forever begin wclk = 1; #(WP / 2); wclk = 0; #(WP / 2); end end
    initial begin #(RO); forever begin rclk = 1; #(RP / 2); rclk = 0; #(RP / 2); end end
    initial begin errs = 0; wn = 0; rn = 0; msg = ""; seed = SEED; end
    always @(posedge go) begin repeat (6) @(negedge wclk); wrst = 0; end
    always @(posedge go) begin repeat (6) @(negedge rclk); rrst = 0; end

    integer rh0 = 0, rh1 = 0, rh2 = 0, wh0 = 0, wh1 = 0, wh2 = 0;
    always @(posedge wclk) begin rh2 = rh1; rh1 = rh0; rh0 = rn; end
    always @(posedge rclk) begin wh2 = wh1; wh1 = wh0; wh0 = wn; end
    always @(posedge wclk) if (!wrst && winc && wfull === 1'b0) begin
        if (wn - rh2 >= 8 && wn - rn < 8) begin
            if (errs == 0) $sformat(msg, "t=%.1f ns: write accepted into a slot freed by a read less than 2 wclk edges ago: the read pointer must cross through a 2-flop synchronizer", $realtime);
            errs = errs + 1;
        end
        if (wn - rn >= 8) begin
            if (errs == 0) $sformat(msg, "t=%.1f ns: write accepted while the FIFO already holds 8 entries (wfull should be 1): overflow", $realtime);
            errs = errs + 1;
        end
        q[wn % 1024] = wdata; wn = wn + 1;
    end
    always @(posedge rclk) if (!rrst && rinc && rempty === 1'b0) begin
        if (rn >= wn) begin
            if (errs == 0) $sformat(msg, "t=%.1f ns: read accepted while the FIFO is empty (rempty should be 1): underflow", $realtime);
            errs = errs + 1;
        end else if (rn >= wh2) begin
            if (errs == 0) $sformat(msg, "t=%.1f ns: entry #%0d read less than 2 rclk edges after it was written: the write pointer must cross through a 2-flop synchronizer", $realtime, rn);
            errs = errs + 1;
        end else if (rdata !== q[rn % 1024]) begin
            if (errs == 0) $sformat(msg, "t=%.1f ns: read #%0d returned 0x%02h, expected 0x%02h", $realtime, rn, rdata, q[rn % 1024]);
            errs = errs + 1;
        end
        rn = rn + 1;
    end
    always @(posedge wclk) if (!wrst && wfull !== 1'b0 && wfull !== 1'b1) begin
        if (errs == 0) $sformat(msg, "t=%.1f ns: wfull is %b after reset", $realtime, wfull);
        errs = errs + 1;
    end
    always @(posedge rclk) if (!rrst && rempty !== 1'b0 && rempty !== 1'b1) begin
        if (errs == 0) $sformat(msg, "t=%.1f ns: rempty is %b after reset", $realtime, rempty);
        errs = errs + 1;
    end
    always @(negedge wclk) begin
        winc  = (wmode == 2) || (wmode == 1 && ($random(seed) & 1));
        wdata = $random(seed);
    end
    always @(negedge rclk) rinc = (rmode == 2) || (rmode == 1 && ($random(seed) & 1));
endmodule
