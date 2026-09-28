`timescale 1ns/1ps
module tb;
    initial begin
        automatic magic3 it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int used[10];
        int s1, s2;
        for (int n = 0; n < 16; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.sq);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (used[v]) used[v] = 0;
                foreach (it.sq[i, j]) if (it.sq[i][j] >= 1 && it.sq[i][j] <= 9) used[it.sq[i][j]]++;
                for (int v = 1; v <= 9; v++) if (used[v] != 1) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                for (int i = 0; i < 3; i++) begin
                    s1 = 0; s2 = 0; for (int j = 0; j < 3; j++) begin s1 += it.sq[i][j]; s2 += it.sq[j][i]; end
                    if (s1 != 15 || s2 != 15) ok = 0;
                end
                s1 = 0; s2 = 0; for (int i = 0; i < 3; i++) begin s1 += it.sq[i][i]; s2 += it.sq[i][2 - i]; end
                if (s1 != 15 || s2 != 15) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 16 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: uses 1..9 exactly once -- e.g. %0s (%0d of 16 results)", first[0], nbad[0]);
        else $display("PASS: uses 1..9 exactly once");
        if (nbad[1]) $display("FAIL: all rows, columns and both diagonals sum to 15 -- e.g. %0s (%0d of 16 results)", first[1], nbad[1]);
        else $display("PASS: all rows, columns and both diagonals sum to 15");
        if (distinct < 5) $display("FAIL: randomness -- only %0d distinct results in 16 calls (need 5)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
