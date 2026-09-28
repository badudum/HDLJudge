`timescale 1ns/1ps
module tb;
    initial begin
        automatic rotated it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int seen_v[16];
        for (int n = 0; n < 150; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.a);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.b[i, j]) if (it.b[i][j] != it.a[2 - j][i]) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (seen_v[v]) seen_v[v] = 0;
                foreach (it.a[i, j]) begin if (seen_v[it.a[i][j]]) ok = 0; seen_v[it.a[i][j]] = 1; end
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 150 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: b is a rotated 90° clockwise -- e.g. %0s (%0d of 150 results)", first[0], nbad[0]);
        else $display("PASS: b is a rotated 90° clockwise");
        if (nbad[1]) $display("FAIL: all elements of a are distinct -- e.g. %0s (%0d of 150 results)", first[1], nbad[1]);
        else $display("PASS: all elements of a are distinct");
        if (distinct < 145) $display("FAIL: randomness -- only %0d distinct results in 150 calls (need 145)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
