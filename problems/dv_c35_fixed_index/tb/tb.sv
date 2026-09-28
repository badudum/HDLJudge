`timescale 1ns/1ps
module tb;
    initial begin
        automatic fixed_idx it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%p", it.arr);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.arr[3] != 42) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (it.arr[7] != it.arr[3] + 1) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                foreach (it.arr[i]) if (i != 3 && it.arr[i] == 42) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: arr[3] is always 42 -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: arr[3] is always 42");
        if (nbad[1]) $display("FAIL: arr[7] = arr[3] + 1 -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: arr[7] = arr[3] + 1");
        if (nbad[2]) $display("FAIL: no other element is 42 -- e.g. %0s (%0d of 200 results)", first[2], nbad[2]);
        else $display("PASS: no other element is 42");
        if (distinct < 195) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 195)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
