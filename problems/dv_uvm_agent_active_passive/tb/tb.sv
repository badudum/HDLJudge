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

class hwlc_seq extends uvm_sequence #(bus_item);
    `uvm_object_utils(hwlc_seq)
    int n = 20;
    function new(string name = "hwlc_seq"); super.new(name); endfunction
    task body();
        bus_item it;
        repeat (n) begin
            it = bus_item::type_id::create("it");
            start_item(it);
            assert(it.randomize());
            finish_item(it);
        end
    endtask
endclass

// Records every item the agent's monitor broadcasts.
class hwlc_sub extends uvm_subscriber #(bus_item);
    `uvm_component_utils(hwlc_sub)
    bit [7:0] got[$];
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void write(bus_item t); got.push_back(t.data); endfunction
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    bus_agent agt_active;
    bus_agent agt_passive;
    hwlc_sub  sub_active;
    hwlc_sub  sub_passive;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        agt_active  = bus_agent::type_id::create("agt_active", this);
        agt_passive = bus_agent::type_id::create("agt_passive", this);
        sub_active  = hwlc_sub::type_id::create("sub_active", this);
        sub_passive = hwlc_sub::type_id::create("sub_passive", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if (agt_active.mon != null)  agt_active.mon.ap.connect(sub_active.analysis_export);
        if (agt_passive.mon != null) agt_passive.mon.ap.connect(sub_passive.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        hwlc_seq seq;
        phase.raise_objection(this);

        seq = hwlc_seq::type_id::create("seq");
        seq.n = 20;
        if (agt_active.sqr != null)
            seq.start(agt_active.sqr);

        fork
            begin
                wait (tb.passive_done);
            end
            begin
                #80us;
            end
        join_any
        disable fork;
        #20;

        hwlc_results::check("agent respects is_active: exactly one driver instance is built (only the active agent)",
            bus_driver::built == 1, $sformatf("bus_driver::built = %0d, expected 1 (one active agent, one passive agent)", bus_driver::built));

        hwlc_results::check("active agent: driver drives items and the monitor observes all of them",
            sub_active.got.size() == 20,
            $sformatf("active agent's monitor observed %0d items, expected 20 (check drv/sqr are built and connected when active)", sub_active.got.size()));

        hwlc_results::check("passive agent: monitor still observes externally-driven bus activity",
            sub_passive.got.size() == 15,
            $sformatf("passive agent's monitor observed %0d items, expected 15 (a passive agent's monitor must still run)", sub_passive.got.size()));

        hwlc_results::check("passive agent: no driver or sequencer is built",
            agt_passive.drv == null && agt_passive.sqr == null,
            "agt_passive.drv or agt_passive.sqr is non-null: a passive agent (is_active == UVM_PASSIVE) must not build a driver or sequencer");

        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        hwlc_results::check("agent builds a monitor unconditionally",
            agt_active.mon != null && agt_passive.mon != null,
            "both agents (active and passive) must always build their monitor");
        hwlc_results::report();
    endfunction
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;

    bus_if vif_a (clk);
    bus_if vif_p (clk);

    bit passive_done = 0;
    task automatic drive_passive_bus();
        for (int i = 0; i < 15; i++) begin
            @(posedge clk);
            vif_p.data  <= 8'($urandom);
            vif_p.valid <= 1'b1;
            @(posedge clk);
            vif_p.valid <= 1'b0;
        end
        passive_done = 1;
    endtask

    initial begin
        vif_p.valid = 1'b0;
        uvm_config_db#(virtual bus_if)::set(null, "*.agt_active.*", "vif", vif_a);
        uvm_config_db#(virtual bus_if)::set(null, "*.agt_passive.*", "vif", vif_p);
        uvm_config_db#(uvm_active_passive_enum)::set(null, "*.agt_active", "is_active", UVM_ACTIVE);
        uvm_config_db#(uvm_active_passive_enum)::set(null, "*.agt_passive", "is_active", UVM_PASSIVE);
        run_test("hwlc_test");
    end

    initial drive_passive_bus();
endmodule
