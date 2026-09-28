`timescale 1ns/1ps
module tb;
    initial begin
        automatic mem_ops it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p %p", it.addr, it.len);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                foreach (it.addr[i]) if (it.len[i] < 1 || it.len[i] > 8 || int'(it.addr[i]) + it.len[i] > 64) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.addr[i]) foreach (it.addr[j]) if (i < j) begin
                    if (!(int'(it.addr[i]) + it.len[i] <= it.addr[j] || int'(it.addr[j]) + it.len[j] <= it.addr[i])) ok = 0;
                end
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: each access is 1..8 bytes inside 0..63 -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: each access is 1..8 bytes inside 0..63");
        if (nbad[1]) $display("FAIL: no two accesses overlap -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: no two accesses overlap");
        if (distinct < 195) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 195)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
