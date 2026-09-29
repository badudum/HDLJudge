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

class hwlc_seq extends uvm_sequence #(cb_item);
    `uvm_object_utils(hwlc_seq)
    int n = 15;
    bit [7:0] sent[$];
    function new(string name = "hwlc_seq"); super.new(name); endfunction
    task body();
        cb_item it;
        repeat (n) begin
            it = cb_item::type_id::create("it");
            start_item(it);
            assert(it.randomize());
            sent.push_back(it.data);
            finish_item(it);
        end
    endtask
endclass

class hwlc_sub extends uvm_subscriber #(cb_item);
    `uvm_component_utils(hwlc_sub)
    bit [7:0] got[$];
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void write(cb_item t); got.push_back(t.data); endfunction
endclass

class hwlc_env extends uvm_env;
    `uvm_component_utils(hwlc_env)
    cb_driver drv;
    uvm_sequencer #(cb_item) sqr;
    cb_monitor mon;
    hwlc_sub sub;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        drv = cb_driver::type_id::create("drv", this);
        sqr = uvm_sequencer #(cb_item)::type_id::create("sqr", this);
        mon = cb_monitor::type_id::create("mon", this);
        sub = hwlc_sub::type_id::create("sub", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.ap.connect(sub.analysis_export);
    endfunction
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    hwlc_env env;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        env = hwlc_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        hwlc_seq before_seq, after_seq;
        invert_callback cb;
        bit ok;
        phase.raise_objection(this);

        // --- phase 1: no callback registered yet -> the driver must pass data through unchanged
        before_seq = hwlc_seq::type_id::create("before_seq");
        before_seq.n = 15;
        before_seq.start(env.sqr);
        #20;

        ok = (env.sub.got.size() == before_seq.n);
        if (ok) foreach (before_seq.sent[i]) if (env.sub.got[i] != before_seq.sent[i]) ok = 0;
        hwlc_results::check("with no callback registered, the driver passes data through unchanged",
            ok, $sformatf("observed %0d items, expected %0d matching the sent data exactly", env.sub.got.size(), before_seq.n));

        // --- phase 2: register the student's callback, then send more items
        cb = new("cb");
        uvm_callbacks#(cb_driver, my_callback)::add(env.drv, cb);

        after_seq = hwlc_seq::type_id::create("after_seq");
        after_seq.n = 15;
        after_seq.start(env.sqr);
        #20;

        ok = (env.sub.got.size() == before_seq.n + after_seq.n);
        if (ok) foreach (after_seq.sent[i]) if (env.sub.got[before_seq.n + i] != (~after_seq.sent[i])) ok = 0;
        hwlc_results::check("once the callback is registered, every item is inverted before it's driven",
            ok, $sformatf("after registering the callback, the driver output did not equal ~data for every item (%0d items observed, expected %0d)",
                env.sub.got.size(), before_seq.n + after_seq.n));

        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        hwlc_results::report();
    endfunction
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;
    cb_if vif (clk);
    initial begin
        uvm_config_db#(virtual cb_if)::set(null, "*", "vif", vif);
        run_test("hwlc_test");
    end
endmodule
