`timescale 1ns/1ps
module tb;
    initial begin
        automatic cond_prob it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int m1, l15, bad;
        for (int n = 0; n < 1000; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d %0d", it.mode, it.len);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.mode && it.len < 8) ok = 0;
                if (!it.mode && it.len > 7) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            m1 += it.mode;
            if (it.mode && it.len == 15) l15++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 1000 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: len is 8..15 when mode = 1 and 0..7 when mode = 0 -- e.g. %0s (%0d of 1000 results)", first[0], nbad[0]);
        else $display("PASS: len is 8..15 when mode = 1 and 0..7 when mode = 0");
        ok = 1'b1; msg = "";
        begin
            if (m1 < 640 || m1 > 760) begin ok = 0; msg = $sformatf("%0d of 1000", m1); end
        end
        if (ok) $display("PASS: P(mode = 1) is about 70 %%"); else $display("FAIL: P(mode = 1) is about 70 %% -- %0s", msg);
        ok = 1'b1; msg = "";
        begin
            if (m1 == 0 || l15 * 100 < m1 * 42 || l15 * 100 > m1 * 58) begin ok = 0; msg = $sformatf("%0d of %0d", l15, m1); end
        end
        if (ok) $display("PASS: P(len = 15 | mode = 1) is about 50 %%"); else $display("FAIL: P(len = 15 | mode = 1) is about 50 %% -- %0s", msg);
        if (distinct < 14) $display("FAIL: randomness -- only %0d distinct results in 1000 calls (need 14)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
