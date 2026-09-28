`timescale 1ns/1ps
module tb;
    initial begin
        automatic rep_rules it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[4];
        string first[4];
        string key, msg;
        bit ok;
        int cnt[256];
        int lens[int];
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d %p", it.len, it.arr);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.len < 5 || it.len > 12 || it.arr.size() != it.len) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                foreach (it.arr[i]) if (it.arr[i] > 9) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                foreach (cnt[v]) cnt[v] = 0;
                foreach (it.arr[i]) begin cnt[it.arr[i]]++; if (cnt[it.arr[i]] > 2) ok = 0; end
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
            ok = 1'b1;
            begin
                foreach (it.arr[i]) if (i > 0 && it.arr[i] == it.arr[i-1]) ok = 0;
            end
            if (!ok) begin nbad[3]++; if (first[3] == "") first[3] = key; end
            lens[it.len] = 1;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: size is between 5 and 12 and equals len -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: size is between 5 and 12 and equals len");
        if (nbad[1]) $display("FAIL: values are 0..9 -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: values are 0..9");
        if (nbad[2]) $display("FAIL: no value appears more than twice -- e.g. %0s (%0d of 200 results)", first[2], nbad[2]);
        else $display("PASS: no value appears more than twice");
        if (nbad[3]) $display("FAIL: no two adjacent elements are equal -- e.g. %0s (%0d of 200 results)", first[3], nbad[3]);
        else $display("PASS: no two adjacent elements are equal");
        ok = 1'b1; msg = "";
        begin
            if (lens.num() != 8) begin ok = 0; msg = $sformatf("only %0d different lengths", lens.num()); end
        end
        if (ok) $display("PASS: all lengths 5..12 occur"); else $display("FAIL: all lengths 5..12 occur -- %0s", msg);
        if (distinct < 180) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 180)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
