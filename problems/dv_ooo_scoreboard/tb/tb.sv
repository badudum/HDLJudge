`timescale 1ns/1ps
// ---------------------------------------------------------------- hidden grading harness
class hwlc_results;
    static string names[$];
    static bit    oks[$];
    static string details[$];
    static function void check(string name, bit ok, string detail = "");
        foreach (names[i]) if (names[i] == name) begin
            if (oks[i] && !ok) begin oks[i] = 0; details[i] = detail; end
            return;
        end
        names.push_back(name); oks.push_back(ok); details.push_back(detail);
    endfunction
    static function void report();
        foreach (names[i])
            if (oks[i]) $display("PASS: %s", names[i]);
            else        $display("FAIL: %s -- %s", names[i], details[i]);
        $display("TB_DONE");
    endfunction
endclass

module tb;
    function automatic txn mk(int id, bit [31:0] d); mk = new(id, d); endfunction
    task automatic main();
        ooo_scoreboard sb = new();
        txn exp_q[$], act_q[$];
        int e_match = 0, e_mis = 0, e_unexp = 0, e_miss = 0;
        int next_id = 0;
        int live[$];
        // Build 400 transactions: ids are unique while outstanding and get reused later.
        for (int i = 0; i < 400; i++) begin
            bit [31:0] d = $urandom;
            int r = $urandom % 100;
            txn e = mk((i * 5) % 64, d);               // unique within a batch of 64, reused by the next batch
            if (r < 5)       begin exp_q.push_back(e); e_miss++; end                       // never produced
            else if (r < 10) begin exp_q.push_back(e); act_q.push_back(mk(e.id, d ^ 32'h80)); e_mis++; end
            else             begin exp_q.push_back(e); act_q.push_back(mk(e.id, d)); e_match++; end
            if (i % 64 == 63) begin
                // deliver this batch of 64: all expected, then actuals in shuffled order,
                // with a few actuals arriving before their expected
                txn a[$];
                a = act_q; a.shuffle();
                for (int k = 0; k < a.size(); k++) if (k % 7 == 3) sb.add_actual(a[k]);
                foreach (exp_q[k]) sb.add_expected(exp_q[k]);
                for (int k = 0; k < a.size(); k++) if (k % 7 != 3) sb.add_actual(a[k]);
                // flush anything still missing from this id window so ids can be reused
                exp_q.delete(); act_q.delete();
                sb.final_check();
                hwlc_results::check("matches out-of-order results", sb.n_match == e_match, $sformatf("after %0d txns: n_match = %0d, expected %0d", i + 1, sb.n_match, e_match));
                hwlc_results::check("detects data mismatches", sb.n_mismatch == e_mis, $sformatf("after %0d txns: n_mismatch = %0d, expected %0d", i + 1, sb.n_mismatch, e_mis));
                hwlc_results::check("reports missing results", sb.n_missing == e_miss, $sformatf("after %0d txns: n_missing = %0d, expected %0d", i + 1, sb.n_missing, e_miss));
                hwlc_results::check("handles actual-before-expected", sb.n_unexpected == 0, $sformatf("n_unexpected = %0d but every actual had an expected", sb.n_unexpected));
                sb = new();
                e_match = 0; e_mis = 0; e_miss = 0;
            end
        end
        // unexpected results
        sb = new();
        sb.add_expected(mk(1, 32'h11));
        sb.add_actual(mk(2, 32'h22));
        sb.add_actual(mk(1, 32'h11));
        sb.add_actual(mk(3, 32'h33));
        sb.final_check();
        hwlc_results::check("reports unexpected results", sb.n_unexpected == 2 && sb.n_match == 1 && sb.n_missing == 0,
            $sformatf("n_unexpected = %0d (expected 2), n_match = %0d (1), n_missing = %0d (0)", sb.n_unexpected, sb.n_match, sb.n_missing));
        // id reuse after completion
        sb = new();
        sb.add_expected(mk(5, 1)); sb.add_actual(mk(5, 1));
        sb.add_expected(mk(5, 2)); sb.add_actual(mk(5, 2));
        sb.add_actual(mk(5, 3));   sb.add_expected(mk(5, 3));
        sb.final_check();
        hwlc_results::check("ids are reused after completion", sb.n_match == 3 && sb.n_mismatch == 0 && sb.n_missing == 0 && sb.n_unexpected == 0,
            $sformatf("n_match=%0d n_mismatch=%0d n_missing=%0d n_unexpected=%0d (expected 3/0/0/0)", sb.n_match, sb.n_mismatch, sb.n_missing, sb.n_unexpected));
        hwlc_results::report();
        $finish;
    endtask
    initial main();
endmodule
