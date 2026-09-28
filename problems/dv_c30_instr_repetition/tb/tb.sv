`timescale 1ns/1ps
module tb;
    initial begin
        automatic instr_stream it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[4];
        string first[4];
        string key, msg;
        bit ok;
        int cnt[8];
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.op);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (cnt[k]) cnt[k] = 0;
                foreach (it.op[i]) cnt[it.op[i]]++;
                foreach (cnt[k]) if (cnt[k] > 5) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.op[i]) if (i < 19 && it.op[i] == 1 && it.op[i+1] == 2) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                foreach (it.op[i]) if (i < 19 && it.op[i] == 0 && it.op[i+1] == 0) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
            ok = 1'b1;
            begin
                if (it.op[19] != 6 && it.op[19] != 7) ok = 0;
            end
            if (!ok) begin nbad[3]++; if (first[3] == "") first[3] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: no opcode appears more than 5 times -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: no opcode appears more than 5 times");
        if (nbad[1]) $display("FAIL: a LOAD is never directly followed by a STORE -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: a LOAD is never directly followed by a STORE");
        if (nbad[2]) $display("FAIL: no two consecutive NOPs -- e.g. %0s (%0d of 200 results)", first[2], nbad[2]);
        else $display("PASS: no two consecutive NOPs");
        if (nbad[3]) $display("FAIL: the stream ends with a branch or jump -- e.g. %0s (%0d of 200 results)", first[3], nbad[3]);
        else $display("PASS: the stream ends with a branch or jump");
        if (distinct < 195) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 195)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
