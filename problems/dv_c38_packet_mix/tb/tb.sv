`timescale 1ns/1ps
module tb;
    initial begin
        automatic pkt_mix it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int nk[3];
        for (int n = 0; n < 1000; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d/%0d", it.kind, it.len);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.kind == pkt_mix::SMALL && !(it.len inside {[1:16]})) ok = 0;
                if (it.kind == pkt_mix::MEDIUM && !(it.len inside {[17:128]})) ok = 0;
                if (it.kind == pkt_mix::LARGE && !(it.len inside {[129:255]})) ok = 0;
                if (it.kind > 2) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            if (it.kind <= 2) nk[it.kind]++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 1000 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: length matches the kind -- e.g. %0s (%0d of 1000 results)", first[0], nbad[0]);
        else $display("PASS: length matches the kind");
        ok = 1'b1; msg = "";
        begin
            if (nk[0] < 540 || nk[0] > 660 || nk[1] < 240 || nk[1] > 360 || nk[2] < 60 || nk[2] > 140) begin ok = 0; msg = $sformatf("SMALL %0d, MEDIUM %0d, LARGE %0d of 1000", nk[0], nk[1], nk[2]); end
        end
        if (ok) $display("PASS: mix is about 60/30/10 %%"); else $display("FAIL: mix is about 60/30/10 %% -- %0s", msg);
        if (distinct < 150) $display("FAIL: randomness -- only %0d distinct results in 1000 calls (need 150)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
