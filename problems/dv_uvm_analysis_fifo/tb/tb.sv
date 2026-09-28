`include "uvm_macros.svh"
import uvm_pkg::*;

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

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    fifo_scoreboard sb;
    uvm_analysis_port #(pkt) exp_ap, act_ap;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        sb = fifo_scoreboard::type_id::create("sb", this);
        exp_ap = new("exp_ap", this);
        act_ap = new("act_ap", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        exp_ap.connect(sb.exp_export);
        act_ap.connect(sb.act_export);
    endfunction
    function pkt mk(int id, bit [31:0] p);
        pkt t = pkt::type_id::create("t");
        t.id = id; t.payload = p;
        return t;
    endfunction
    task run_phase(uvm_phase phase);
        bit [31:0] pl[100];
        phase.raise_objection(this);
        foreach (pl[i]) pl[i] = $urandom;
        fork
            // predictor: all expected packets early, in bursts
            for (int i = 0; i < 100; i++) begin
                exp_ap.write(mk(i, pl[i]));
                if (i % 10 == 9) #($urandom_range(1, 50) * 1ns);
            end
            // DUT monitor: 97 actual packets later, with latency; 7 corrupted
            for (int i = 0; i < 97; i++) begin
                #($urandom_range(0, 20) * 1ns);
                act_ap.write(mk(i, (i % 13 == 5 && i < 90) ? pl[i] ^ 32'h1 : pl[i]));
            end
        join
        #100ns;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        hwlc_results::check("counts matches", sb.n_match == 90, $sformatf("n_match = %0d, expected 90", sb.n_match));
        hwlc_results::check("counts mismatches", sb.n_mismatch == 7, $sformatf("n_mismatch = %0d, expected 7", sb.n_mismatch));
        hwlc_results::check("reports leftover expected packets", sb.leftover == 3, $sformatf("leftover = %0d, expected 3 (expected packets never matched by the end of the test)", sb.leftover));
        hwlc_results::report();
    endfunction
endclass

module tb;
    initial run_test("hwlc_test");
endmodule
