`timescale 1ns/1ps
module tb;
    initial begin
        automatic sudoku6 it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int used[8];
        for (int n = 0; n < 10; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.g);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.g[i, j]) if (it.g[i][j] < 1 || it.g[i][j] > 6) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                for (int u = 0; u < 6; u++) begin
                    foreach (used[v]) used[v] = 0; for (int k = 0; k < 6; k++) used[it.g[u][k]]++; for (int v = 1; v <= 6; v++) if (used[v] != 1) ok = 0;
                    foreach (used[v]) used[v] = 0; for (int k = 0; k < 6; k++) used[it.g[k][u]]++; for (int v = 1; v <= 6; v++) if (used[v] != 1) ok = 0;
                    foreach (used[v]) used[v] = 0; for (int k = 0; k < 6; k++) used[it.g[(u / 2) * 2 + k / 3][(u % 2) * 3 + k % 3]]++; for (int v = 1; v <= 6; v++) if (used[v] != 1) ok = 0;
                end
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                if (it.g[0][0] != 1 || it.g[5][5] != 6) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 10 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: values are 1..6 -- e.g. %0s (%0d of 10 results)", first[0], nbad[0]);
        else $display("PASS: values are 1..6");
        if (nbad[1]) $display("FAIL: rows, columns and 2x3 boxes contain each value once -- e.g. %0s (%0d of 10 results)", first[1], nbad[1]);
        else $display("PASS: rows, columns and 2x3 boxes contain each value once");
        if (nbad[2]) $display("FAIL: the given clues are respected -- e.g. %0s (%0d of 10 results)", first[2], nbad[2]);
        else $display("PASS: the given clues are respected");
        if (distinct < 7) $display("FAIL: randomness -- only %0d distinct results in 10 calls (need 7)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
