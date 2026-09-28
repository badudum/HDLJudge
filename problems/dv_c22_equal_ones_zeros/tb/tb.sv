`timescale 1ns/1ps
module tb;
    initial begin
        automatic balanced it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h", it.v);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if ($countones(it.v) != 8) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (!it.v[15]) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                for (int i = 0; i < 13; i++) if (it.v[i+:4] == 4'hF || it.v[i+:4] == 4'h0) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: eight ones and eight zeros -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: eight ones and eight zeros");
        if (nbad[1]) $display("FAIL: MSB is 1 -- e.g. %0s (%0d of 300 results)", first[1], nbad[1]);
        else $display("PASS: MSB is 1");
        if (nbad[2]) $display("FAIL: no run of four equal bits -- e.g. %0s (%0d of 300 results)", first[2], nbad[2]);
        else $display("PASS: no run of four equal bits");
        if (distinct < 250) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 250)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
