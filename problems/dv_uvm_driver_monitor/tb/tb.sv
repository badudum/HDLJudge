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

class hwlc_seq extends uvm_sequence #(stream_item);
    `uvm_object_utils(hwlc_seq)
    bit [7:0] sent[$];
    function new(string name = "hwlc_seq"); super.new(name); endfunction
    task body();
        stream_item it;
        repeat (300) begin
            it = stream_item::type_id::create("it");
            start_item(it);
            it.data = 8'($urandom);
            finish_item(it);
            sent.push_back(it.data);
        end
    endtask
endclass

class hwlc_sb extends uvm_subscriber #(stream_item);
    `uvm_component_utils(hwlc_sb)
    stream_item got[$];
    bit [7:0] vals[$];
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void write(stream_item t);
        got.push_back(t);
        vals.push_back(t == null ? 8'h00 : t.data);
    endfunction
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    stream_driver  drv;
    stream_monitor mon;
    hwlc_sb        sb;
    uvm_sequencer #(stream_item) sqr;
    hwlc_seq seq;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        drv = stream_driver::type_id::create("drv", this);
        mon = stream_monitor::type_id::create("mon", this);
        sb  = hwlc_sb::type_id::create("sb", this);
        sqr = uvm_sequencer#(stream_item)::type_id::create("sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        if (mon.ap == null) `uvm_fatal("HWLC", "stream_monitor.ap is null: create the analysis port in the constructor or build_phase")
        mon.ap.connect(sb.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = hwlc_seq::type_id::create("seq");
        fork
            begin seq.start(sqr); repeat (20) @(posedge tb.clk); end
            begin #500us; hwlc_results::check("driver delivers every item in order", 0, $sformatf("timed out after %0d of 300 items (driver stuck?)", seq.sent.size())); end
        join_any
        disable fork;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        int n = tb.nrx;
        bit ok = (n == seq.sent.size() && n == 300);
        string d = $sformatf("DUT received %0d bytes, sequence sent %0d", n, seq.sent.size());
        for (int i = 0; ok && i < n; i++) if (tb.rx[i] != seq.sent[i]) begin ok = 0; d = $sformatf("byte #%0d: DUT received 0x%02h, expected 0x%02h", i, tb.rx[i], seq.sent[i]); end
        hwlc_results::check("driver delivers every item in order", ok, d);
        hwlc_results::check("driver holds valid and data while stalled", tb.stall_viol == 0, tb.stall_msg);
        hwlc_results::check("monitor reports each transfer exactly once", sb.vals.size() == n,
            $sformatf("monitor wrote %0d items, %0d transfers happened on the bus", sb.vals.size(), n));
        ok = sb.vals.size() == n; d = "";
        for (int i = 0; ok && i < n; i++) if (sb.vals[i] != tb.rx[i]) begin ok = 0; d = $sformatf("item #%0d: monitor saw 0x%02h, bus carried 0x%02h", i, sb.vals[i], tb.rx[i]); end
        hwlc_results::check("monitor data matches the bus", ok, d);
        ok = 1; d = "";
        for (int i = 0; ok && i < sb.got.size() && i < n; i++) if (sb.got[i] == null || sb.got[i].data != tb.rx[i]) begin
            ok = 0; d = $sformatf("item #%0d changed after it was written (0x%02h now, 0x%02h on the bus): create a new item for every transfer", i, sb.got[i] == null ? 0 : sb.got[i].data, tb.rx[i]);
        end
        hwlc_results::check("monitor publishes a new object per transfer", ok, d);
        hwlc_results::report();
    endfunction
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;
    stream_if vif (clk);
    bit [7:0] rx[$];
    int nrx = 0, stall_viol = 0;
    string stall_msg = "";
    logic pv = 0, pr = 0;
    logic [7:0] pd;
    // sink with random backpressure
    always @(posedge clk) begin
        if (!vif.rst && vif.valid === 1'b1 && vif.ready) begin rx.push_back(vif.data); nrx++; end
        if (!vif.rst && pv && !pr && (vif.valid !== 1'b1 || vif.data !== pd)) begin
            if (stall_viol == 0) stall_msg = $sformatf("t=%0t: valid/data changed while ready was low", $time);
            stall_viol++;
        end
        pv = vif.valid === 1'b1; pr = vif.ready; pd = vif.data;
        vif.ready <= ($urandom % 3) != 0;
    end
    initial begin
        vif.rst = 1; vif.ready = 0;
        repeat (5) @(posedge clk);
        vif.rst <= 0;
    end
    initial begin
        uvm_config_db#(virtual stream_if)::set(null, "*", "vif", vif);
        run_test("hwlc_test");
    end
endmodule
