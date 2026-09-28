`timescale 1ns/1ps
module tb;
    initial begin
        automatic coloring it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.grid);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.grid[i, j]) if (j < 3 && it.grid[i][j] == it.grid[i][j+1]) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.grid[i, j]) if (i < 3 && it.grid[i][j] == it.grid[i+1][j]) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: horizontal neighbours differ -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: horizontal neighbours differ");
        if (nbad[1]) $display("FAIL: vertical neighbours differ -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: vertical neighbours differ");
        if (distinct < 190) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 190)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
