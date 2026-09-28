`timescale 1ns/1ps
module tb;
    initial begin
        automatic sum_item it = new;
        int bad_sum = 0, bad_range = 0, bad_even = 0, fails = 0, distinct = 0;
        int seen[string];
        int vals[8][int];
        string first_bad = "";
        int s;
        string key;
        for (int n = 0; n < 300; n++) begin
            s = 0;                      // (a declaration initializer here would run only once)
            if (!it.randomize()) begin
                fails++;
                continue;
            end
            key = $sformatf("%p", it.arr);
            if (!seen.exists(key)) begin
                seen[key] = 1;
                distinct++;
            end
            foreach (it.arr[i]) begin
                s += it.arr[i];
                vals[i][it.arr[i]] = 1;
                if (it.arr[i] < 5 || it.arr[i] > 60) bad_range++;
            end
            if (s != 200) begin
                bad_sum++;
                if (first_bad == "") first_bad = $sformatf("%p sums to %0d", it.arr, s);
            end
            if (it.arr[0] % 2 != 0) bad_even++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else       $display("PASS: randomize() succeeds");
        if (bad_sum) $display("FAIL: sum is exactly 200 -- %0s (%0d arrays)", first_bad, bad_sum);
        else         $display("PASS: sum is exactly 200");
        if (bad_range) $display("FAIL: element range 5..60 -- %0d elements out of range", bad_range);
        else           $display("PASS: element range 5..60");
        if (bad_even) $display("FAIL: arr[0] is even -- %0d odd values", bad_even);
        else          $display("PASS: arr[0] is even");
        begin
            int narrow = 0;
            for (int i = 0; i < 8; i++) if (vals[i].num() < 10) narrow++;
            if (distinct < 250 || narrow > 0)
                $display("FAIL: randomness -- %0d distinct arrays of 300, %0d indices with fewer than 10 values", distinct, narrow);
            else
                $display("PASS: randomness (%0d distinct arrays)", distinct);
        end
        $display("TB_DONE");
        $finish;
    end
endmodule
