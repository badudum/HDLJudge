`timescale 1ns/1ps
module tb;
    initial begin
        automatic three_same it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int hist[16];
        int threes, others;
        for (int n = 0; n < 150; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.arr);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (hist[v]) hist[v] = 0;
                foreach (it.arr[i]) hist[it.arr[i]]++;
                threes = 0; others = 0;
                foreach (hist[v]) begin if (hist[v] == 3) threes++; else if (hist[v] > 1) others++; end
                if (threes != 1 || others != 0) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 150 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: one value appears exactly 3 times, all others once -- e.g. %0s (%0d of 150 results)", first[0], nbad[0]);
        else $display("PASS: one value appears exactly 3 times, all others once");
        if (distinct < 120) $display("FAIL: randomness -- only %0d distinct results in 150 calls (need 120)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
