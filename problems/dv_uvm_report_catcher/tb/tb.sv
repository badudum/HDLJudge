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
    demote_catcher c;
    int w0, e0;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        c = new("c");
        uvm_report_cb::add(null, c);
    endfunction
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        w0 = uvm_report_server::get_server().get_severity_count(UVM_WARNING);
        e0 = uvm_report_server::get_server().get_severity_count(UVM_ERROR);
        repeat (3) `uvm_error("KNOWN_BUG", "waived: tracked in bug 1234")
        repeat (2) `uvm_error("OTHER", "a real error")
        `uvm_error("X", "this mentions KNOWN_BUG in the text but has another id")
        repeat (5) `uvm_info("NOISY", "chatter", UVM_NONE)
        repeat (2) `uvm_info("QUIET", "useful info", UVM_NONE)
        `uvm_warning("NOISY", "a warning with the noisy id")
        #10ns;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        uvm_report_server s = uvm_report_server::get_server();
        hwlc_results::check("demotes KNOWN_BUG errors to warnings", c.n_demoted == 3 && s.get_id_count("KNOWN_BUG") == 3,
            $sformatf("n_demoted = %0d (expected 3), KNOWN_BUG reports = %0d", c.n_demoted, s.get_id_count("KNOWN_BUG")));
        hwlc_results::check("other errors stay errors", s.get_severity_count(UVM_ERROR) - e0 == 3,
            $sformatf("%0d UVM_ERRORs, expected 3 (2 OTHER + 1 X)", s.get_severity_count(UVM_ERROR) - e0));
        hwlc_results::check("warnings include the demoted errors", s.get_severity_count(UVM_WARNING) - w0 == 4,
            $sformatf("%0d UVM_WARNINGs, expected 4", s.get_severity_count(UVM_WARNING) - w0));
        hwlc_results::check("swallows NOISY info messages only", c.n_caught == 5 && s.get_id_count("NOISY") == 1 && s.get_id_count("QUIET") == 2,
            $sformatf("n_caught = %0d (expected 5), NOISY reports reaching the server = %0d (expected 1), QUIET = %0d (expected 2)", c.n_caught, s.get_id_count("NOISY"), s.get_id_count("QUIET")));
        hwlc_results::report();
    endfunction
endclass

module tb;
    initial run_test("hwlc_test");
endmodule
