`timescale 1ns/1ps
module tb;
    initial begin
        automatic knight_tour it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int vis[12];
        int dr, dc;
        for (int n = 0; n < 8; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p%p", it.r, it.c);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.r[k]) if (it.r[k] > 2) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (vis[k]) vis[k] = 0;
                foreach (it.r[k]) if (it.r[k] <= 2) vis[it.r[k] * 4 + it.c[k]]++;
                foreach (vis[k]) if (vis[k] != 1) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                foreach (it.r[k]) if (k > 0) begin
                    dr = int'(it.r[k]) - int'(it.r[k-1]); dc = int'(it.c[k]) - int'(it.c[k-1]);
                    if (dr < 0) dr = -dr; if (dc < 0) dc = -dc;
                    if (!((dr == 1 && dc == 2) || (dr == 2 && dc == 1))) ok = 0;
                end
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 8 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: coordinates are on the 3 x 4 board -- e.g. %0s (%0d of 8 results)", first[0], nbad[0]);
        else $display("PASS: coordinates are on the 3 x 4 board");
        if (nbad[1]) $display("FAIL: every square is visited exactly once -- e.g. %0s (%0d of 8 results)", first[1], nbad[1]);
        else $display("PASS: every square is visited exactly once");
        if (nbad[2]) $display("FAIL: consecutive squares are a knight's move apart -- e.g. %0s (%0d of 8 results)", first[2], nbad[2]);
        else $display("PASS: consecutive squares are a knight's move apart");
        if (distinct < 5) $display("FAIL: randomness -- only %0d distinct results in 8 calls (need 5)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
