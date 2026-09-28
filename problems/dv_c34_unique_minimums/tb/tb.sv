`timescale 1ns/1ps
module tb;
    initial begin
        automatic two_mins it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int ma, mb, ca, cb;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p%p", it.a, it.b);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                ma = 99; mb = 99; foreach (it.a[i, j]) begin if (it.a[i][j] < ma) ma = it.a[i][j]; if (it.b[i][j] < mb) mb = it.b[i][j]; end
                ca = 0; cb = 0; foreach (it.a[i, j]) begin if (it.a[i][j] == ma) ca++; if (it.b[i][j] == mb) cb++; end
                if (ca != 1 || cb != 1) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (!(ma < mb)) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: each matrix has a unique minimum -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: each matrix has a unique minimum");
        if (nbad[1]) $display("FAIL: min(a) < min(b) -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: min(a) < min(b)");
        if (distinct < 195) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 195)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
