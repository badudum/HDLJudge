`timescale 1ns/1ps
module tb;
    initial begin
        automatic queens it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        for (int n = 0; n < 24; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.col);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.col[i]) foreach (it.col[j]) if (i < j) begin
                    if (it.col[i] == it.col[j]) ok = 0;
                    if (int'(it.col[i]) - int'(it.col[j]) == j - i || int'(it.col[j]) - int'(it.col[i]) == j - i) ok = 0;
                end
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 24 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: no two queens attack each other -- e.g. %0s (%0d of 24 results)", first[0], nbad[0]);
        else $display("PASS: no two queens attack each other");
        if (distinct < 12) $display("FAIL: randomness -- only %0d distinct results in 24 calls (need 12)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
