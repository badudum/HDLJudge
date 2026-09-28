`timescale 1ns/1ps
module tb;
    initial begin
        automatic interleave it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p %p", it.a, it.b);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.a[i]) if (it.a[i] >= it.b[i]) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.a[i]) if (i < 5 && it.b[i] >= it.a[i+1]) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: a[i] < b[i] for every i -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: a[i] < b[i] for every i");
        if (nbad[1]) $display("FAIL: b[i] < a[i+1] (the arrays interleave) -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: b[i] < a[i+1] (the arrays interleave)");
        if (distinct < 190) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 190)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
