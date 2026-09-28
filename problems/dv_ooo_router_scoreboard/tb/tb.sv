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
    int e_match = 0, e_misroute = 0, e_order = 0, e_corrupt = 0, e_missing = 0, e_unknown = 0;
    task automatic check_all(router_scoreboard sb, string when);
        sb.final_check();
        hwlc_results::check("in-order per port, interleaved across ports", sb.n_match == e_match, $sformatf("%s: n_match = %0d, expected %0d", when, sb.n_match, e_match));
        hwlc_results::check("detects misrouted packets", sb.n_misroute == e_misroute, $sformatf("%s: n_misroute = %0d, expected %0d", when, sb.n_misroute, e_misroute));
        hwlc_results::check("detects reordering within a port", sb.n_order == e_order, $sformatf("%s: n_order = %0d, expected %0d", when, sb.n_order, e_order));
        hwlc_results::check("detects corrupted payloads", sb.n_corrupt == e_corrupt, $sformatf("%s: n_corrupt = %0d, expected %0d", when, sb.n_corrupt, e_corrupt));
        hwlc_results::check("reports dropped and unknown packets", sb.n_missing == e_missing && sb.n_unknown == e_unknown,
            $sformatf("%s: n_missing = %0d (expected %0d), n_unknown = %0d (expected %0d)", when, sb.n_missing, e_missing, sb.n_unknown, e_unknown));
    endtask

    function automatic pkt mkp(int uid, int dest, bit [31:0] pl); mkp = new(uid, dest, pl); endfunction
    task automatic main();
        router_scoreboard sb;
        pkt q[4][$];
        pkt p;
        int uid = 0;
        // ---- clean traffic: 4 ports, interleaved
        sb = new();
        for (int i = 0; i < 400; i++) begin
            p = new(uid++, $urandom % 4, $urandom);
            sb.add_input(p);
            q[p.dest].push_back(p);
            if ($urandom % 3 == 0) begin
                int d = $urandom % 4;
                if (q[d].size() > 0) begin sb.add_output(d, q[d].pop_front()); e_match++; end
            end
        end
        for (int d = 0; d < 4; d++) while (q[d].size() > 0) begin sb.add_output(d, q[d].pop_front()); e_match++; end
        check_all(sb, "clean traffic");

        // ---- directed errors
        e_match = 0;
        sb = new();
        begin
            pkt a = new(1000, 0, 32'hA), b = new(1001, 0, 32'hB), c = new(1002, 1, 32'hC), d = new(1003, 2, 32'hD),
                e = new(1004, 3, 32'hE), f = new(1005, 3, 32'hF), g = new(1006, 1, 32'h6);
            sb.add_input(a); sb.add_input(b); sb.add_input(c); sb.add_input(d); sb.add_input(e); sb.add_input(f); sb.add_input(g);
            sb.add_output(0, b);  e_order++;          // b overtakes a on port 0
            sb.add_output(0, a);  e_match++;
            sb.add_output(3, c);  e_misroute++;       // c belongs to port 1
            sb.add_output(2, mkp(1003, 2, 32'hBAD)); e_corrupt++;
            sb.add_output(3, e);  e_match++;
            sb.add_output(2, mkp(4242, 2, 0)); e_unknown++;
            e_missing = 2;                            // f and g never come out
        end
        check_all(sb, "directed errors");
        hwlc_results::report();
        $finish;
    endtask
    initial main();
endmodule
