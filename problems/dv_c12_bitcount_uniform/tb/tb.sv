`timescale 1ns/1ps
module tb;
    initial begin
        automatic popc_uniform it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[1];
        string first[1];
        string key, msg;
        bit ok;
        int bcnt[9];
        int lo, hi;
        for (int n = 0; n < 900; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h", it.v);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            bcnt[$countones(it.v)]++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 900 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        ok = 1'b1; msg = "";
        begin
            lo = 1000; hi = 0;
            foreach (bcnt[k]) begin if (bcnt[k] < lo) lo = bcnt[k]; if (bcnt[k] > hi) hi = bcnt[k]; end
            if (lo < 60 || hi > 145) begin ok = 0; msg = $sformatf("bin counts %p", bcnt); end
        end
        if (ok) $display("PASS: every bit count 0..8 occurs about 1/9 of the time"); else $display("FAIL: every bit count 0..8 occurs about 1/9 of the time -- %0s", msg);
        if (distinct < 150) $display("FAIL: randomness -- only %0d distinct results in 900 calls (need 150)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
