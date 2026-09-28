`timescale 1ns/1ps
module tb;
    initial begin
        automatic bin_matrix it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int rs, cs;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.m);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.m[i]) begin rs = 0; foreach (it.m[i][j]) rs += it.m[i][j]; if (rs != 2) ok = 0; end
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                for (int j = 0; j < 4; j++) begin cs = 0; for (int i = 0; i < 4; i++) cs += it.m[i][j]; if (cs != 2) ok = 0; end
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: every row has exactly two ones -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: every row has exactly two ones");
        if (nbad[1]) $display("FAIL: every column has exactly two ones -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: every column has exactly two ones");
        if (distinct < 60) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 60)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
