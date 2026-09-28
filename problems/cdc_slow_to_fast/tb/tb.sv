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

    reg  cf = 0, cs = 0, rst = 1, d = 0, chk = 0;
    wire q, rise;
    reg  r1, r2, r3;
    integer k, nrise_ref, nrise_dut;
    sync_edge dut (.clk_fast(cf), .rst(rst), .d_slow(d), .q(q), .rise(rise));
    always #5 cf = ~cf;
    initial begin #3.25; forever #18.5 cs = ~cs; end
    always @(posedge cf) if (rst) begin r1 <= 0; r2 <= 0; r3 <= 0; end else begin r1 <= d; r2 <= r1; r3 <= r2; end
    always @(negedge cf) if (chk) begin
        if (q !== r2) `FAIL((detail, "t=%.1f ns: q = %b, expected %b (d_slow sampled 2 fast edges ago)", $realtime, q, r2))
        else if (rise !== (r2 & ~r3)) `FAIL((detail, "t=%.1f ns: rise = %b, expected %b", $realtime, rise, r2 & ~r3))
        if (rise === 1'b1) nrise_dut = nrise_dut + 1;
        if (r2 & ~r3) nrise_ref = nrise_ref + 1;
    end

    initial begin
        if ($test$plusargs("vcd")) begin $dumpfile("wave.vcd"); $dumpvars(0, dut); end
        nrise_ref = 0; nrise_dut = 0;
        repeat (3) @(posedge cf);
        @(negedge cf) rst = 0; chk = 1;

        start_test;
        for (k = 0; k < 10; k = k + 1) begin @(posedge cs); d = ~d; end
        end_test("q follows d after two fast edges");

        start_test;
        @(posedge cs) d = 1; repeat (6) @(posedge cs);
        @(posedge cs) d = 0; repeat (2) @(posedge cs);
        @(posedge cs) d = 1; @(posedge cs) d = 0; repeat (2) @(posedge cs);
        if (nrise_dut != nrise_ref) `FAIL((detail, "%0d rise pulses, expected %0d", nrise_dut, nrise_ref))
        end_test("one pulse per rising edge");

        start_test;
        for (k = 0; k < 400; k = k + 1) begin @(posedge cs); if ($random & 1) d = ~d; end
        @(negedge cf) rst = 1; @(negedge cf); @(negedge cf) rst = 0;
        for (k = 0; k < 50; k = k + 1) begin @(posedge cs); if ($random & 1) d = ~d; end
        repeat (4) @(posedge cf);
        if (nrise_dut != nrise_ref) `FAIL((detail, "%0d rise pulses, expected %0d", nrise_dut, nrise_ref))
        end_test("400 random slow-domain changes");
        $display("TB_DONE");
        $finish;
    end
endmodule
