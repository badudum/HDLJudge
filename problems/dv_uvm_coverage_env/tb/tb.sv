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

class hwlc_cov_x extends bus_cov;           // factory override used by the hidden test
    `uvm_component_utils(hwlc_cov_x)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    my_env env_on, env_off, env_def;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        set_type_override_by_type(bus_cov::get_type(), hwlc_cov_x::get_type());
        uvm_config_db#(int)::set(this, "env_on", "has_coverage", 1);
        uvm_config_db#(int)::set(this, "env_off", "has_coverage", 0);
        env_on  = my_env::type_id::create("env_on", this);
        env_off = my_env::type_id::create("env_off", this);
        env_def = my_env::type_id::create("env_def", this);
    endfunction
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #400ns;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        hwlc_cov_x x;
        hwlc_results::check("coverage created when enabled", env_on.cov != null, "env with has_coverage = 1 has no coverage component");
        hwlc_results::check("coverage created by default", env_def.cov != null, "has_coverage not set: coverage should default to on");
        hwlc_results::check("no coverage when disabled", env_off.cov == null, "env with has_coverage = 0 still created a coverage component");
        hwlc_results::check("components created through the factory", env_on.cov != null && $cast(x, env_on.cov),
            "the factory override of bus_cov was ignored: create components with type_id::create()");
        hwlc_results::check("agent and scoreboard always present", env_on.agent != null && env_off.agent != null && env_def.agent != null &&
            env_on.sb != null && env_off.sb != null && env_def.sb != null, "agent / sb missing in some env");
        if (env_on.sb != null && env_off.sb != null && env_def.sb != null)
            hwlc_results::check("monitor connected to the scoreboard", env_on.sb.n == 25 && env_off.sb.n == 25 && env_def.sb.n == 25,
                $sformatf("scoreboards received %0d / %0d / %0d of 25 items", env_on.sb.n, env_off.sb.n, env_def.sb.n));
        if (env_on.cov != null && env_def.cov != null)
            hwlc_results::check("monitor connected to coverage", env_on.cov.n == 25 && env_def.cov.n == 25,
                $sformatf("coverage received %0d / %0d of 25 items", env_on.cov.n, env_def.cov.n));
        hwlc_results::report();
    endfunction
endclass

module tb;
    initial run_test("hwlc_test");
endmodule
