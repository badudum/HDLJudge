`timescale 1ns/1ps
module tb;
    initial begin
        automatic pow4 it = new;
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
                if (it.v == 0 || (it.v & (it.v - 1)) != 0 || (it.v & 32'h5555_5555) == 0) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: v is a power of 4 -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: v is a power of 4");
        if (distinct < 15) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 15)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
