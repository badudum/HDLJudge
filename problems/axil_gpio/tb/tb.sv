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
    reg  [7:0] gpio_in = 0, mo = 0, md = 0;
    wire [7:0] gpio_out, gpio_oe;
    integer k;
    reg [31:0] v;
    reg [7:0] a;

    axil_gpio dut (.aclk(aclk), .aresetn(aresetn), .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wvalid(wvalid), .wready(wready), .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arvalid(arvalid), .arready(arready), .rdata(rdata), .rresp(rresp), .rvalid(rvalid), .rready(rready), .gpio_in(gpio_in), .gpio_out(gpio_out), .gpio_oe(gpio_oe));

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        reset_dut;

        start_test;
        rd(8'h00, 0, 2'b00); rd(8'h04, 0, 2'b00);
        if (gpio_out !== 8'h00 || gpio_oe !== 8'h00) `FAIL((detail, "after reset gpio_out = 0x%02h, gpio_oe = 0x%02h", gpio_out, gpio_oe))
        end_test("reset state");

        start_test;
        wr(8'h00, 32'h5A, 4'h1, 3, 2'b00); mo = 8'h5A;
        wr(8'h04, 32'hF0, 4'h1, 3, 2'b00); md = 8'hF0;
        if (gpio_out !== mo || gpio_oe !== md) `FAIL((detail, "gpio_out = 0x%02h, gpio_oe = 0x%02h (expected 0x%02h, 0x%02h)", gpio_out, gpio_oe, mo, md))
        rd(8'h00, mo, 2'b00); rd(8'h04, md, 2'b00);
        wr(8'h00, 32'hFFFFFF33, 4'hE, 3, 2'b00);
        rd(8'h00, mo, 2'b00);
        end_test("DATA_OUT and DIR drive the pins");

        start_test;
        gpio_in = 8'hC3; repeat (4) @(posedge aclk);
        rd(8'h08, 32'hC3, 2'b00);
        wr(8'h08, 32'h00, 4'hF, 3, 2'b00);
        rd(8'h08, 32'hC3, 2'b00);
        gpio_in = 8'h3C; repeat (4) @(posedge aclk);
        rd(8'h08, 32'h3C, 2'b00);
        end_test("DATA_IN reads the synchronized pins");

        start_test;
        wr(8'h00, 32'h0F, 4'h1, 3, 2'b00); mo = 8'h0F;
        wr(8'h0C, 32'hFF, 4'h1, 3, 2'b00); mo = 8'hF0;
        if (gpio_out !== mo) `FAIL((detail, "gpio_out = 0x%02h after TOGGLE 0xFF, expected 0x%02h", gpio_out, mo))
        wr(8'h0C, 32'h81, 4'h1, 3, 2'b00); mo = 8'h71;
        rd(8'h00, mo, 2'b00); rd(8'h0C, 32'h0, 2'b00);
        end_test("TOGGLE flips bits");

        start_test;
        maxdly = 0;
        wr(8'h04, 32'h11, 4'hF, 1, 2'b00); rd(8'h04, 32'h11, 2'b00);
        wr(8'h04, 32'h22, 4'hF, 2, 2'b00); rd(8'h04, 32'h22, 2'b00);
        maxdly = 5;
        for (k = 0; k < 20; k = k + 1) begin
            v = $random(seed) & 32'hFF;
            wr(8'h04, v, 4'hF, k % 3, 2'b00); rd(8'h04, v, 2'b00);
        end
        maxdly = 3;
        end_test("AW and W in either order");

        start_test;
        maxdly = 8;
        for (k = 0; k < 20; k = k + 1) begin
            v = $random(seed) & 32'hFF;
            wr(8'h04, v, 4'hF, 3, 2'b00); rd(8'h04, v, 2'b00);
        end
        maxdly = 3;
        end_test("holds B and R until the master is ready");

        md = v[7:0];
        start_test;
        for (k = 0; k < 400; k = k + 1) begin
            if (($random(seed) & 7) == 0) begin gpio_in = $random(seed); repeat (3) @(posedge aclk); end
            a = ($random(seed) & 3) == 0 ? $random(seed) : (($random(seed) & 3) << 2);
            v = $random(seed);
            if ($random(seed) & 1) begin
                wr(a, v, $random(seed), 3, 2'b00);
                if (wstrb[0]) begin
                    if (a == 8'h00) mo = v[7:0];
                    if (a == 8'h04) md = v[7:0];
                    if (a == 8'h0C) mo = mo ^ v[7:0];
                end
                if (gpio_out !== mo || gpio_oe !== md) `FAIL((detail, "after write 0x%08h to 0x%02h: gpio_out = 0x%02h, gpio_oe = 0x%02h (expected 0x%02h, 0x%02h)", v, a, gpio_out, gpio_oe, mo, md))
            end else
                rd(a, a == 8'h00 ? mo : a == 8'h04 ? md : a == 8'h08 ? gpio_in : 32'h0, 2'b00);
        end
        end_test("400 random transactions");
        $display("TB_DONE");
        $finish;
    end
endmodule
