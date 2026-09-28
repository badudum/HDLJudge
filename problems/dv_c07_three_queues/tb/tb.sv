`timescale 1ns/1ps
module tb;
    initial begin
        automatic three_q it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int used[13];
        int total;
        for (int n = 0; n < 150; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.owner);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (used[v]) used[v] = 0;
                total = 0;
                for (int k = 0; k < 3; k++) foreach (it.q[k][i]) begin if (it.q[k][i] < 1 || it.q[k][i] > 12) ok = 0; else used[it.q[k][i]]++; total++; end
                for (int v = 1; v <= 12; v++) if (used[v] != 1) ok = 0;
                if (total != 12) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (it.q[0].size() == 0 || it.q[1].size() == 0 || it.q[2].size() == 0) ok = 0;
                if (it.q[0].size() == it.q[1].size() || it.q[1].size() == it.q[2].size() || it.q[0].size() == it.q[2].size()) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 150 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: every item 1..12 is in exactly one queue -- e.g. %0s (%0d of 150 results)", first[0], nbad[0]);
        else $display("PASS: every item 1..12 is in exactly one queue");
        if (nbad[1]) $display("FAIL: the three queues are non-empty and of different sizes -- e.g. %0s (%0d of 150 results)", first[1], nbad[1]);
        else $display("PASS: the three queues are non-empty and of different sizes");
        if (distinct < 130) $display("FAIL: randomness -- only %0d distinct results in 150 calls (need 130)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
