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

    reg  aclk = 0, aresetn = 0;
    reg  [7:0]  awaddr = 0, araddr = 0;
    reg         awvalid = 0, wvalid = 0, bready = 0, arvalid = 0, rready = 0;
    reg  [31:0] wdata = 0;
    reg  [3:0]  wstrb = 0;
    wire        awready, wready, bvalid, arready, rvalid;
    wire [1:0]  bresp, rresp;
    wire [31:0] rdata;
    integer seed = 7, maxdly = 3;
    integer aw_n = 0, w_n = 0, b_n = 0, ar_n = 0, r_n = 0;
    reg  pb_v = 0, pb_r = 0, pr_v = 0, pr_r = 0;
    reg  [1:0] pb_resp, pr_resp;
    reg  [31:0] pr_data;
    always #5 aclk = ~aclk;

    // ---------------- protocol checker (sampled on every rising edge)
    always @(posedge aclk) if (aresetn) begin
        if (bvalid === 1'b1 && !((aw_n < w_n ? aw_n : w_n) > b_n)) `FAIL((detail, "t=%.1f ns: BVALID asserted before both the AW and W handshakes of a write", $realtime))
        if (rvalid === 1'b1 && !(ar_n > r_n)) `FAIL((detail, "t=%.1f ns: RVALID asserted without an accepted read address", $realtime))
        if (pb_v && !pb_r && (bvalid !== 1'b1 || bresp !== pb_resp)) `FAIL((detail, "t=%.1f ns: BVALID/BRESP changed before BREADY", $realtime))
        if (pr_v && !pr_r && (rvalid !== 1'b1 || rdata !== pr_data || rresp !== pr_resp)) `FAIL((detail, "t=%.1f ns: RVALID/RDATA/RRESP changed before RREADY", $realtime))
        if (awvalid && awready) aw_n = aw_n + 1;
        if (wvalid && wready)   w_n  = w_n + 1;
        if (bvalid && bready)   b_n  = b_n + 1;
        if (arvalid && arready) ar_n = ar_n + 1;
        if (rvalid && rready)   r_n  = r_n + 1;
        pb_v = bvalid; pb_r = bready; pb_resp = bresp;
        pr_v = rvalid; pr_r = rready; pr_resp = rresp; pr_data = rdata;
    end

    function integer dly; input integer dummy; begin dly = maxdly == 0 ? 0 : ($random(seed) & 32'h7fffffff) % (maxdly + 1); end endfunction

    // order: 0 = AW and W together, 1 = AW first, 2 = W first, 3 = random
    task axi_write(input [7:0] a, input [31:0] d, input [3:0] s, input integer order, output [1:0] resp);
        integer t, da, dw, o;
        begin
            o  = order == 3 ? ($random(seed) & 32'h7fffffff) % 3 : order;
            da = o == 2 ? 1 + dly(0) : 0;
            dw = o == 1 ? 1 + dly(0) : 0;
            resp = 2'bxx;
            fork
                begin
                    repeat (da) @(posedge aclk);
                    #1 awaddr = a; awvalid = 1;
                    t = 0;
                    @(posedge aclk);
                    while (awready !== 1'b1 && t < 100) begin t = t + 1; @(posedge aclk); end
                    if (t >= 100) `FAIL((detail, "write 0x%02h: no AWREADY within 100 cycles", a))
                    #1 awvalid = 0;
                end
                begin : wch
                    integer tw;
                    repeat (dw) @(posedge aclk);
                    #1 wdata = d; wstrb = s; wvalid = 1;
                    tw = 0;
                    @(posedge aclk);
                    while (wready !== 1'b1 && tw < 100) begin tw = tw + 1; @(posedge aclk); end
                    if (tw >= 100) `FAIL((detail, "write 0x%02h: no WREADY within 100 cycles", a))
                    #1 wvalid = 0;
                end
            join
            repeat (dly(0)) @(posedge aclk);
            #1 bready = 1;
            t = 0;
            @(posedge aclk);
            while (bvalid !== 1'b1 && t < 100) begin t = t + 1; @(posedge aclk); end
            if (t >= 100) `FAIL((detail, "write 0x%02h: no BVALID within 100 cycles", a))
            resp = bresp;
            #1 bready = 0;
        end
    endtask

    task axi_read(input [7:0] a, output [31:0] d, output [1:0] resp);
        integer t;
        begin
            d = 32'hxxxxxxxx; resp = 2'bxx;
            repeat (dly(0)) @(posedge aclk);
            #1 araddr = a; arvalid = 1;
            t = 0;
            @(posedge aclk);
            while (arready !== 1'b1 && t < 100) begin t = t + 1; @(posedge aclk); end
            if (t >= 100) `FAIL((detail, "read 0x%02h: no ARREADY within 100 cycles", a))
            #1 arvalid = 0;
            repeat (dly(0)) @(posedge aclk);
            #1 rready = 1;
            t = 0;
            @(posedge aclk);
            while (rvalid !== 1'b1 && t < 100) begin t = t + 1; @(posedge aclk); end
            if (t >= 100) `FAIL((detail, "read 0x%02h: no RVALID within 100 cycles", a))
            d = rdata; resp = rresp;
            #1 rready = 0;
        end
    endtask

    reg [31:0] got;
    reg [1:0]  gr, gw;

    // write, expecting a response code
    task wr(input [7:0] a, input [31:0] d, input [3:0] s, input integer order, input [1:0] exp_resp);
        begin
            axi_write(a, d, s, order, gw);
            if (gw !== exp_resp) `FAIL((detail, "write 0x%08h to 0x%02h (wstrb %b): BRESP = %b, expected %b", d, a, s, gw, exp_resp))
        end
    endtask

    // read, expecting data (under mask) and a response code
    task rd(input [7:0] a, input [31:0] exp, input [1:0] exp_resp);
        begin
            axi_read(a, got, gr);
            if (gr !== exp_resp) `FAIL((detail, "read 0x%02h: RRESP = %b, expected %b", a, gr, exp_resp))
            else if (got !== exp) `FAIL((detail, "read 0x%02h: RDATA = 0x%08h, expected 0x%08h", a, got, exp))
        end
    endtask

    function [31:0] merge(input [31:0] old, input [31:0] d, input [3:0] s);
        integer i;
        begin
            merge = old;
            for (i = 0; i < 4; i = i + 1) if (s[i]) merge[8*i +: 8] = d[8*i +: 8];
        end
    endfunction

    task reset_dut;
        begin
            aresetn = 0; repeat (4) @(posedge aclk); #1 aresetn = 1; @(posedge aclk);
        end
    endtask
    reg [31:0] status_in = 32'h0, nev = 0;
    reg event_in = 0;
    integer k;
    reg [31:0] v;
    reg [7:0] a;
    always @(posedge aclk) if (!aresetn) nev <= 0; else if (event_in) nev <= nev + 1;

    axil_status dut (.aclk(aclk), .aresetn(aresetn), .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready), .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready), .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready), .status_in(status_in), .event_in(event_in));

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        reset_dut;

        start_test;
        rd(8'h00, 32'h48574C43, 2'b00);
        rd(8'h00, 32'h48574C43, 2'b00);
        end_test("ID register");

        start_test;
        status_in = 32'hFEED0001; rd(8'h04, 32'hFEED0001, 2'b00);
        status_in = 32'h00C0FFEE; rd(8'h04, 32'h00C0FFEE, 2'b00);
        end_test("STATUS reflects status_in");

        start_test;
        rd(8'h08, 32'd0, 2'b00);
        for (k = 0; k < 13; k = k + 1) begin @(posedge aclk); #1 event_in = 1; @(posedge aclk); #1 event_in = 0; end
        rd(8'h08, 32'd13, 2'b00);
        @(posedge aclk); #1 event_in = 1; repeat (20) @(posedge aclk); #1 event_in = 0;
        rd(8'h08, 32'd33, 2'b00);
        end_test("event counter");

        start_test;
        wr(8'h00, 32'h0, 4'hF, 3, 2'b10); wr(8'h08, 32'h0, 4'hF, 3, 2'b10); wr(8'h40, 32'h0, 4'hF, 3, 2'b10);
        rd(8'h00, 32'h48574C43, 2'b00); rd(8'h08, 32'd33, 2'b00);
        end_test("writes return SLVERR");

        start_test;
        rd(8'h0C, 32'h0, 2'b10); rd(8'h10, 32'h0, 2'b10); rd(8'hFC, 32'h0, 2'b10);
        end_test("unmapped reads return SLVERR");

        start_test;
        maxdly = 6;
        for (k = 0; k < 300; k = k + 1) begin
            @(negedge aclk) event_in = $random(seed); status_in = $random(seed);
            @(negedge aclk) event_in = 0;
            a = ($random(seed) & 3) == 0 ? $random(seed) : (($random(seed) % 3) << 2);
            if (($random(seed) & 3) == 0) wr(a, $random(seed), 4'hF, 3, 2'b10);
            else rd(a, a == 8'h00 ? 32'h48574C43 : a == 8'h04 ? status_in : a == 8'h08 ? nev : 32'h0, a <= 8'h08 && a[1:0] == 0 ? 2'b00 : 2'b10);
        end
        end_test("300 random transactions with backpressure");
        $display("TB_DONE");
        $finish;
    end
endmodule
