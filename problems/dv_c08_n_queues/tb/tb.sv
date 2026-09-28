`timescale 1ns/1ps
module tb;
    initial begin
        automatic n_queues it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int used[10];
        int total;
        for (int n = 0; n < 150; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.owner);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (used[v]) used[v] = 0;
                total = 0;
                for (int k = 0; k < 4; k++) foreach (it.q[k][i]) begin if (it.q[k][i] < 0 || it.q[k][i] > 9) ok = 0; else used[it.q[k][i]]++; total++; end
                foreach (used[v]) if (used[v] != 1) ok = 0;
                if (total != 10) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                for (int k = 0; k < 4; k++) if (it.q[k].size() < 2 || it.q[k].size() > 3) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                for (int k = 0; k < 4; k++) foreach (it.q[k][i]) if (i > 0 && it.q[k][i] <= it.q[k][i-1]) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 150 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: each item 0..9 is in exactly one queue -- e.g. %0s (%0d of 150 results)", first[0], nbad[0]);
        else $display("PASS: each item 0..9 is in exactly one queue");
        if (nbad[1]) $display("FAIL: every queue holds 2 or 3 items -- e.g. %0s (%0d of 150 results)", first[1], nbad[1]);
        else $display("PASS: every queue holds 2 or 3 items");
        if (nbad[2]) $display("FAIL: items in each queue are in ascending order -- e.g. %0s (%0d of 150 results)", first[2], nbad[2]);
        else $display("PASS: items in each queue are in ascending order");
        if (distinct < 130) $display("FAIL: randomness -- only %0d distinct results in 150 calls (need 130)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
