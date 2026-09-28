`timescale 1ns/1ps
module tb;
    initial begin
        automatic low_match it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int same;
        for (int n = 0; n < 2000; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h%h", it.a, it.b);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            if (it.a[3:0] == it.b[3:0]) same++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 2000 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        ok = 1'b1; msg = "";
        begin
            if (same < 50 || same > 160) begin ok = 0; msg = $sformatf("%0d of 2000 (expected about 100)", same); end
        end
        if (ok) $display("PASS: P(a[3:0] == b[3:0]) is about 5 %%"); else $display("FAIL: P(a[3:0] == b[3:0]) is about 5 %% -- %0s", msg);
        if (distinct < 1500) $display("FAIL: randomness -- only %0d distinct results in 2000 calls (need 1500)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
