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
    alu_cov cov;
    uvm_analysis_port #(alu_item) ap;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        cov = alu_cov::type_id::create("cov", this);
        ap = new("ap", this);
    endfunction
    function void connect_phase(uvm_phase phase); ap.connect(cov.analysis_export); endfunction
    task send(alu_op_e op, bit [7:0] a, bit [7:0] b);
        alu_item t = alu_item::type_id::create("t");
        t.op = op; t.a = a; t.b = b;
        ap.write(t);
        #1ns;
    endtask
    function bit near(real x, real y); return (x - y < 0.01) && (y - x < 0.01); endfunction
    task run_phase(uvm_phase phase);
        real c;
        phase.raise_objection(this);
        c = cov.get_coverage();
        hwlc_results::check("coverage starts at 0", near(c, 0.0), $sformatf("get_coverage() = %0.2f before any item", c));
        send(OP_ADD, 8'd5, 8'd7);
        hwlc_results::check("op bins", cov.op_hits[OP_ADD] == 1 && cov.op_hits[OP_SUB] == 0, $sformatf("after one ADD: op_hits = '{%0d,%0d,%0d,%0d}", cov.op_hits[0], cov.op_hits[1], cov.op_hits[2], cov.op_hits[3]));
        hwlc_results::check("operand bins (zero / max / other)", cov.a_bins[2] == 1 && cov.a_bins[0] == 0, $sformatf("after a=5: a_bins = '{%0d,%0d,%0d}", cov.a_bins[0], cov.a_bins[1], cov.a_bins[2]));
        c = cov.get_coverage();
        hwlc_results::check("get_coverage() percentage", near(c, 100.0 * 2 / 12), $sformatf("after (ADD, a=5): %0.2f%%, expected %0.2f%%", c, 100.0 * 2 / 12));
        send(OP_SUB, 8'd0, 8'd1);  send(OP_SUB, 8'd0, 8'd9);  send(OP_AND, 8'hFF, 8'd0);
        hwlc_results::check("op bins", cov.op_hits[OP_SUB] == 2 && cov.op_hits[OP_AND] == 1, $sformatf("op_hits = '{%0d,%0d,%0d,%0d}", cov.op_hits[0], cov.op_hits[1], cov.op_hits[2], cov.op_hits[3]));
        hwlc_results::check("operand bins (zero / max / other)", cov.a_bins[0] == 2 && cov.a_bins[1] == 1 && cov.a_bins[2] == 1, $sformatf("a_bins = '{%0d,%0d,%0d}", cov.a_bins[0], cov.a_bins[1], cov.a_bins[2]));
        hwlc_results::check("cross op x zero-operand", cov.zero_cross[OP_SUB] == 2 && cov.zero_cross[OP_AND] == 1 && cov.zero_cross[OP_ADD] == 0,
            $sformatf("zero_cross = '{%0d,%0d,%0d,%0d}", cov.zero_cross[0], cov.zero_cross[1], cov.zero_cross[2], cov.zero_cross[3]));
        c = cov.get_coverage();
        hwlc_results::check("get_coverage() percentage", near(c, 100.0 * 8 / 12), $sformatf("%0.2f%%, expected %0.2f%%", c, 100.0 * 8 / 12));
        send(OP_XOR, 8'd3, 8'd0);  send(OP_ADD, 8'd1, 8'hFF);  send(OP_XOR, 8'd9, 8'd9);
        c = cov.get_coverage();
        hwlc_results::check("get_coverage() percentage", near(c, 100.0 * 11 / 12), $sformatf("%0.2f%%, expected %0.2f%%", c, 100.0 * 11 / 12));
        send(OP_ADD, 8'd0, 8'd0);
        c = cov.get_coverage();
        hwlc_results::check("reaches 100%", near(c, 100.0), $sformatf("%0.2f%% after all 12 bins were hit", c));
        repeat (500) send(alu_op_e'($urandom), 8'($urandom), 8'($urandom));
        c = cov.get_coverage();
        hwlc_results::check("reaches 100%", near(c, 100.0), $sformatf("%0.2f%% after 500 more random items", c));
        hwlc_results::check("op bins", cov.op_hits[0] + cov.op_hits[1] + cov.op_hits[2] + cov.op_hits[3] == 508, "op_hits do not add up to the number of items");
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase); hwlc_results::report(); endfunction
endclass

module tb;
    initial run_test("hwlc_test");
endmodule
