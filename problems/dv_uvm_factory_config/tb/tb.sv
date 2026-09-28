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

class hwlc_checker extends uvm_component;
    `uvm_component_utils(hwlc_checker)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void report_phase(uvm_phase phase);
        base_test t;
        parity_driver pd;
        bit ok;
        void'($cast(t, get_parent()));
        hwlc_results::check("config object reaches the env", t != null && t.env.cfg != null && t.env.cfg.n_items == 25 && t.env.cfg.enable_parity == 1,
            (t == null || t.env.cfg == null) ? "no env_cfg" : $sformatf("cfg.n_items = %0d, enable_parity = %0d (expected 25, 1)", t.env.cfg.n_items, t.env.cfg.enable_parity));
        hwlc_results::check("driver replaced through the factory", t != null && $cast(pd, t.env.drv),
            "env.drv is not a parity_driver: set a type override before the env is built");
        hwlc_results::check("sequence length from config", t != null && t.env.drv.n == 25, $sformatf("%0d items driven, expected 25", t == null ? 0 : t.env.drv.n));
        ok = t != null && t.sent.size() == 25;
        if (ok) foreach (t.sent[i]) if (t.sent[i].parity !== ^t.sent[i].data) ok = 0;
        hwlc_results::check("parity computed by the new driver", ok && pd != null && pd.n_parity == 25,
            $sformatf("parity bits wrong or n_parity = %0d (expected 25)", pd == null ? 0 : pd.n_parity));
        hwlc_results::report();
    endfunction
endclass

module tb;
    initial run_test("my_test");
endmodule
