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

class hwlc_log;
    static realtime cfg_t[$];
    static bit [15:0] cfg_w[$];
    static realtime data_t[$];
endclass

class hwlc_cfg_drv extends uvm_driver #(cfg_item);
    `uvm_component_utils(hwlc_cfg_drv)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            #30ns;
            hwlc_log::cfg_t.push_back($realtime); hwlc_log::cfg_w.push_back({req.addr, req.data});
            seq_item_port.item_done();
        end
    endtask
endclass

class hwlc_data_drv extends uvm_driver #(data_item);
    `uvm_component_utils(hwlc_data_drv)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            #10ns;
            hwlc_log::data_t.push_back($realtime);
            seq_item_port.item_done();
        end
    endtask
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    hwlc_cfg_drv cdrv; hwlc_data_drv ddrv;
    uvm_sequencer #(cfg_item) csqr; uvm_sequencer #(data_item) dsqr;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        cdrv = hwlc_cfg_drv::type_id::create("cdrv", this); ddrv = hwlc_data_drv::type_id::create("ddrv", this);
        csqr = uvm_sequencer#(cfg_item)::type_id::create("csqr", this); dsqr = uvm_sequencer#(data_item)::type_id::create("dsqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        cdrv.seq_item_port.connect(csqr.seq_item_export); ddrv.seq_item_port.connect(dsqr.seq_item_export);
    endfunction
    task run_phase(uvm_phase phase);
        top_vseq v;
        phase.raise_objection(this);
        v = top_vseq::type_id::create("v");
        v.cfg_sqr = csqr; v.data_sqr = dsqr;
        fork
            v.start(null);
            #100us;
        join_any
        disable fork;
        #50ns;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        int nc = hwlc_log::cfg_w.size(), nd = hwlc_log::data_t.size();
        realtime d0 = nd ? hwlc_log::data_t[0] : 0, dl = nd ? hwlc_log::data_t[nd - 1] : 0;
        hwlc_results::check("burst of 8 data items", nd == 8, $sformatf("%0d data items driven, expected 8", nd));
        hwlc_results::check("four register writes", nc == 4, $sformatf("%0d configuration writes, expected 4", nc));
        if (nc == 4 && nd == 8) begin
            hwlc_results::check("configuration before data", hwlc_log::cfg_w[0] == 16'h0001 && hwlc_log::cfg_w[1] == 16'h0408 && hwlc_log::cfg_t[1] < d0,
                $sformatf("first writes %04h, %04h (expected 0001, 0408) must finish before the first data item", hwlc_log::cfg_w[0], hwlc_log::cfg_w[1]));
            hwlc_results::check("status write overlaps the burst", hwlc_log::cfg_w[2] == 16'h08AB && hwlc_log::cfg_t[2] > d0 && hwlc_log::cfg_t[2] < dl,
                $sformatf("third write %04h at %0t: expected 08AB, completing while the burst runs (%0t .. %0t)", hwlc_log::cfg_w[2], hwlc_log::cfg_t[2], d0, dl));
            hwlc_results::check("disable after everything", hwlc_log::cfg_w[3] == 16'h0000 && hwlc_log::cfg_t[3] > dl,
                $sformatf("last write %04h at %0t: expected 0000 after the last data item (%0t)", hwlc_log::cfg_w[3], hwlc_log::cfg_t[3], dl));
        end else begin
            hwlc_results::check("configuration before data", 0, "wrong number of items");
            hwlc_results::check("status write overlaps the burst", 0, "wrong number of items");
            hwlc_results::check("disable after everything", 0, "wrong number of items");
        end
        hwlc_results::report();
    endfunction
endclass

module tb;
    initial run_test("hwlc_test");
endmodule
