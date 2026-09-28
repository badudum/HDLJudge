`timescale 1ns/1ps
module tb;
    initial begin
        automatic five_bits it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int runs;
        for (int n = 0; n < 600; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h", it.v);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if ($countones(it.v) != 5) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            if ($countones(it.v & (it.v >> 1)) == 4) runs++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 600 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: exactly 5 bits are set -- e.g. %0s (%0d of 600 results)", first[0], nbad[0]);
        else $display("PASS: exactly 5 bits are set");
        ok = 1'b1; msg = "";
        begin
            if (runs < 135 || runs > 225) begin ok = 0; msg = $sformatf("%0d of 600 (expected about 180)", runs); end
        end
        if (ok) $display("PASS: the 5 ones are consecutive in about 30 %% of results"); else $display("FAIL: the 5 ones are consecutive in about 30 %% of results -- %0s", msg);
        if (distinct < 300) $display("FAIL: randomness -- only %0d distinct results in 600 calls (need 300)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
