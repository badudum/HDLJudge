`timescale 1ns/1ps
module tb;
    initial begin
        automatic ttt it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int nx, no;
        bit xw, ow;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.b);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.b[i, j]) if (it.b[i][j] > 2) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                nx = 0; no = 0; foreach (it.b[i, j]) begin if (it.b[i][j] == 1) nx++; if (it.b[i][j] == 2) no++; end
                if (nx != no + 1) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                xw = 0; ow = 0;
                for (int k = 0; k < 3; k++) begin
                    if (it.b[k][0] == 1 && it.b[k][1] == 1 && it.b[k][2] == 1) xw = 1;
                    if (it.b[0][k] == 1 && it.b[1][k] == 1 && it.b[2][k] == 1) xw = 1;
                    if (it.b[k][0] == 2 && it.b[k][1] == 2 && it.b[k][2] == 2) ow = 1;
                    if (it.b[0][k] == 2 && it.b[1][k] == 2 && it.b[2][k] == 2) ow = 1;
                end
                if (it.b[0][0] == 1 && it.b[1][1] == 1 && it.b[2][2] == 1) xw = 1;
                if (it.b[0][2] == 1 && it.b[1][1] == 1 && it.b[2][0] == 1) xw = 1;
                if (it.b[0][0] == 2 && it.b[1][1] == 2 && it.b[2][2] == 2) ow = 1;
                if (it.b[0][2] == 2 && it.b[1][1] == 2 && it.b[2][0] == 2) ow = 1;
                if (!xw || ow) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: cells are empty, X or O -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: cells are empty, X or O");
        if (nbad[1]) $display("FAIL: X moved first: #X = #O + 1 -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: X moved first: #X = #O + 1");
        if (nbad[2]) $display("FAIL: X has three in a row and O does not -- e.g. %0s (%0d of 200 results)", first[2], nbad[2]);
        else $display("PASS: X has three in a row and O does not");
        if (distinct < 150) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 150)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
