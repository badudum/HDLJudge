`timescale 1ns/1ps
module tb;
    initial begin
        automatic two_groups it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int runs, isolated;
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h", it.v);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                runs = $countones(it.v & ~(it.v << 1));
                if (runs != 2) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if ((it.v & ~(it.v << 1) & ~(it.v >> 1)) != 0) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: the ones form exactly two groups -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: the ones form exactly two groups");
        if (nbad[1]) $display("FAIL: every group has at least two ones -- e.g. %0s (%0d of 300 results)", first[1], nbad[1]);
        else $display("PASS: every group has at least two ones");
        if (distinct < 250) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 250)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
