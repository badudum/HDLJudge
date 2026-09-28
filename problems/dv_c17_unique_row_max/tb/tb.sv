`timescale 1ns/1ps
module tb;
    initial begin
        automatic row_max it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int rmax[4];
        for (int n = 0; n < 150; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.m);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (rmax[i]) begin rmax[i] = 0; foreach (it.m[i][j]) if (it.m[i][j] > rmax[i]) rmax[i] = it.m[i][j]; end
                for (int i = 1; i < 4; i++) if (rmax[i] <= rmax[i-1]) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 150 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: row maxima are strictly increasing (hence unique) -- e.g. %0s (%0d of 150 results)", first[0], nbad[0]);
        else $display("PASS: row maxima are strictly increasing (hence unique)");
        if (distinct < 145) $display("FAIL: randomness -- only %0d distinct results in 150 calls (need 145)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
