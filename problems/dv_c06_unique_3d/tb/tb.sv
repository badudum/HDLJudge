`timescale 1ns/1ps
module tb;
    initial begin
        automatic unique3d it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int seen_v[64];
        for (int n = 0; n < 60; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.cube);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (seen_v[v]) seen_v[v] = 0;
                foreach (it.cube[a, b, c]) begin if (seen_v[it.cube[a][b][c]]) ok = 0; seen_v[it.cube[a][b][c]] = 1; end
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 60 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: all 27 elements are different -- e.g. %0s (%0d of 60 results)", first[0], nbad[0]);
        else $display("PASS: all 27 elements are different");
        if (distinct < 55) $display("FAIL: randomness -- only %0d distinct results in 60 calls (need 55)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
