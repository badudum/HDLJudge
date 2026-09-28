`timescale 1ns/1ps
module tb;
    initial begin
        automatic no_zz it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h", it.v);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                for (int i = 0; i < 15; i++) if (!it.v[i] && !it.v[i+1]) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: no two adjacent zero bits -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: no two adjacent zero bits");
        if (distinct < 250) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 250)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
