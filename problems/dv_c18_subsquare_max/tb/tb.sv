`timescale 1ns/1ps
module tb;
    initial begin
        automatic quad_max it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int qm[4];
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.m);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (qm[q]) qm[q] = 0;
                foreach (it.m[i, j]) if (it.m[i][j] > qm[(i / 2) * 2 + j / 2]) qm[(i / 2) * 2 + j / 2] = it.m[i][j];
                foreach (qm[q]) if (qm[q] != 5 + 3 * q) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: the maximum of 2 × 2 quadrant q is 5 + 3q -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: the maximum of 2 × 2 quadrant q is 5 + 3q");
        if (distinct < 190) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 190)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
