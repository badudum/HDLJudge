`timescale 1ns/1ps
module tb;
    initial begin
        automatic size_q it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int sizes[int];
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.q);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.q.size() < 3 || it.q.size() > 8) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.q[i]) if (it.q[i] >= 10 * it.q.size()) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                foreach (it.q[i]) if (i > 0 && it.q[i] <= it.q[i-1]) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
            sizes[it.q.size()] = 1;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: size is 3..8 -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: size is 3..8");
        if (nbad[1]) $display("FAIL: every element is below 10 * size -- e.g. %0s (%0d of 300 results)", first[1], nbad[1]);
        else $display("PASS: every element is below 10 * size");
        if (nbad[2]) $display("FAIL: elements are strictly ascending -- e.g. %0s (%0d of 300 results)", first[2], nbad[2]);
        else $display("PASS: elements are strictly ascending");
        ok = 1'b1; msg = "";
        begin
            if (sizes.num() != 6) begin ok = 0; msg = $sformatf("only %0d different sizes", sizes.num()); end
        end
        if (ok) $display("PASS: all sizes 3..8 occur"); else $display("FAIL: all sizes 3..8 occur -- %0s", msg);
        if (distinct < 280) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 280)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
