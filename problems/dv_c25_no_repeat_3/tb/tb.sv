`timescale 1ns/1ps
module tb;
    initial begin
        automatic draws5 it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int hist[$];
        int trans[5][5];
        int pairs;
        for (int n = 0; n < 400; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d", it.val);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.val > 4) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (hist[i]) if (hist[i] == it.val) ok = 0;
                if (hist.size() > 0 && it.val <= 4 && hist[hist.size()-1] <= 4) trans[hist[hist.size()-1]][it.val]++;
                hist.push_back(it.val);
                if (hist.size() > 3) void'(hist.pop_front());
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 400 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: values are 0..4 -- e.g. %0s (%0d of 400 results)", first[0], nbad[0]);
        else $display("PASS: values are 0..4");
        if (nbad[1]) $display("FAIL: a drawn value does not reappear in the next 3 draws -- e.g. %0s (%0d of 400 results)", first[1], nbad[1]);
        else $display("PASS: a drawn value does not reappear in the next 3 draws");
        ok = 1'b1; msg = "";
        begin
            pairs = 0;
            foreach (trans[a, b]) if (trans[a][b] > 0) pairs++;
            if (pairs < 12) begin ok = 0; msg = $sformatf("only %0d different (prev, next) pairs", pairs); end
        end
        if (ok) $display("PASS: the sequence is not a fixed rotation"); else $display("FAIL: the sequence is not a fixed rotation -- %0s", msg);
        if (distinct < 5) $display("FAIL: randomness -- only %0d distinct results in 400 calls (need 5)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
