`timescale 1ns/1ps
module tb;
    initial begin
        automatic perm10 it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int used[10];
        int pos0[10];
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.perm);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (used[v]) used[v] = 0;
                foreach (it.perm[i]) if (it.perm[i] >= 0 && it.perm[i] <= 9) used[it.perm[i]]++;
                foreach (used[v]) if (used[v] != 1) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            if (it.perm[0] >= 0 && it.perm[0] <= 9) pos0[it.perm[0]]++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: perm is a permutation of 0..9 -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: perm is a permutation of 0..9");
        ok = 1'b1; msg = "";
        begin
            foreach (pos0[v]) if (pos0[v] == 0) begin ok = 0; msg = $sformatf("value %0d never came first", v); end
        end
        if (ok) $display("PASS: every value appears in the first position"); else $display("FAIL: every value appears in the first position -- %0s", msg);
        if (distinct < 195) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 195)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
