`timescale 1ns/1ps
module tb;
    initial begin
        automatic window4 it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int hist[$];
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d", it.val);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (hist[i]) if (hist[i] == it.val) ok = 0;
                hist.push_back(it.val);
                if (hist.size() > 3) void'(hist.pop_front());
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: each value differs from the previous three results -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: each value differs from the previous three results");
        if (distinct < 16) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 16)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
