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

interface hwlc_reg_if (input logic clk);
    logic sel = 0, wr = 0;
    logic [7:0] addr;
    logic [31:0] wdata, rdata;
endinterface

class hwlc_driver extends uvm_driver #(bus_item);
    `uvm_component_utils(hwlc_driver)
    virtual hwlc_reg_if vif;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase); void'(uvm_config_db#(virtual hwlc_reg_if)::get(this, "", "vif", vif)); endfunction
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.clk);
            vif.sel <= 1; vif.wr <= req.write; vif.addr <= req.addr; vif.wdata <= req.data;
            @(posedge vif.clk);
            if (!req.write) req.data = vif.rdata;
            vif.sel <= 0; vif.wr <= 0;
            seq_item_port.item_done();
        end
    endtask
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    hwlc_driver drv;
    uvm_sequencer #(bus_item) sqr;
    regs_block rm;
    bus_adapter adapter;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        drv = hwlc_driver::type_id::create("drv", this);
        sqr = uvm_sequencer#(bus_item)::type_id::create("sqr", this);
        rm = regs_block::type_id::create("rm");
        rm.build();
        rm.lock_model();
        adapter = bus_adapter::type_id::create("adapter");
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        rm.default_map.set_sequencer(sqr, adapter);
        rm.default_map.set_auto_predict(1);
    endfunction
    task run_phase(uvm_phase phase);
        uvm_status_e st;
        uvm_reg_data_t v;
        phase.raise_objection(this);
        rm.reset();
        hwlc_results::check("reset values", rm.ctrl.get() == 32'h0000_1000 && rm.status.get() == 0 && rm.data.get() == 0,
            $sformatf("after reset(): ctrl=0x%08h status=0x%08h data=0x%08h (expected 0x00001000, 0, 0)", rm.ctrl.get(), rm.status.get(), rm.data.get()));
        hwlc_results::check("register addresses", rm.ctrl.get_address() == 'h0 && rm.status.get_address() == 'h4 && rm.data.get_address() == 'h8,
            $sformatf("addresses ctrl=0x%0h status=0x%0h data=0x%0h (expected 0x0, 0x4, 0x8)", rm.ctrl.get_address(), rm.status.get_address(), rm.data.get_address()));
        hwlc_results::check("field layout", rm.ctrl.en.get_lsb_pos() == 0 && rm.ctrl.en.get_n_bits() == 1 && rm.ctrl.mode.get_lsb_pos() == 1 &&
            rm.ctrl.mode.get_n_bits() == 2 && rm.ctrl.prescale.get_lsb_pos() == 8 && rm.ctrl.prescale.get_n_bits() == 8 &&
            rm.status.busy.get_lsb_pos() == 0 && rm.status.err.get_lsb_pos() == 1 && rm.data.data.get_n_bits() == 32,
            "a field has the wrong position or width");
        hwlc_results::check("field access policies", rm.ctrl.en.get_access() == "RW" && rm.ctrl.prescale.get_access() == "RW" &&
            rm.status.busy.get_access() == "RO" && rm.status.err.get_access() == "W1C" && rm.data.data.get_access() == "RW",
            $sformatf("access: en=%s prescale=%s busy=%s err=%s data=%s", rm.ctrl.en.get_access(), rm.ctrl.prescale.get_access(),
                      rm.status.busy.get_access(), rm.status.err.get_access(), rm.data.data.get_access()));

        rm.data.write(st, 32'hDEADBEEF);
        hwlc_results::check("frontdoor write reaches the DUT", st == UVM_IS_OK && tb.r_data == 32'hDEADBEEF, $sformatf("DUT data register = 0x%08h after data.write(0xDEADBEEF)", tb.r_data));
        rm.ctrl.write(st, 32'h0000_2305);
        hwlc_results::check("frontdoor write reaches the DUT", tb.r_ctrl == 32'h0000_2305, $sformatf("DUT ctrl register = 0x%08h after ctrl.write(0x2305)", tb.r_ctrl));
        tb.r_data = 32'h1234_5678;
        rm.data.read(st, v);
        hwlc_results::check("frontdoor read returns the DUT value", st == UVM_IS_OK && v == 32'h1234_5678, $sformatf("data.read() = 0x%08h, DUT holds 0x12345678", v));
        rm.ctrl.read(st, v);
        hwlc_results::check("frontdoor read returns the DUT value", v == 32'h0000_2305 && rm.ctrl.prescale.get_mirrored_value() == 8'h23,
            $sformatf("ctrl.read() = 0x%08h, prescale mirror = 0x%0h", v, rm.ctrl.prescale.get_mirrored_value()));
        tb.r_busy = 1; tb.r_err = 1;
        rm.status.read(st, v);
        hwlc_results::check("frontdoor read returns the DUT value", v == 32'h3, $sformatf("status.read() = 0x%08h, expected 0x3", v));
        rm.status.write(st, 32'h2);          // W1C clears err
        hwlc_results::check("W1C field clears in DUT and mirror", tb.r_err == 0 && rm.status.err.get_mirrored_value() == 0 && rm.status.busy.get_mirrored_value() == 1,
            $sformatf("after writing 1 to err: DUT err=%0d, mirror err=%0d busy=%0d (expected 0, 0, 1)", tb.r_err, rm.status.err.get_mirrored_value(), rm.status.busy.get_mirrored_value()));
        rm.data.mirror(st, UVM_CHECK);
        hwlc_results::check("mirror check passes", uvm_report_server::get_server().get_severity_count(UVM_ERROR) == 0,
            $sformatf("%0d UVM errors (mirror mismatch?)", uvm_report_server::get_server().get_severity_count(UVM_ERROR)));
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase); hwlc_results::report(); endfunction
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;
    hwlc_reg_if vif (clk);
    logic [31:0] r_ctrl = 32'h0000_1000, r_data = 0;
    logic r_busy = 0, r_err = 0;
    // DUT register block
    always @(posedge clk) if (vif.sel && vif.wr) begin
        case (vif.addr)
            8'h00: r_ctrl = vif.wdata & 32'h0000_FF07;
            8'h04: if (vif.wdata[1]) r_err = 1'b0;
            8'h08: r_data = vif.wdata;
            default: ;
        endcase
    end
    assign vif.rdata = vif.addr == 8'h00 ? r_ctrl : vif.addr == 8'h04 ? {30'd0, r_err, r_busy} : vif.addr == 8'h08 ? r_data : 32'd0;
    initial begin
        uvm_config_db#(virtual hwlc_reg_if)::set(null, "*", "vif", vif);
        run_test("hwlc_test");
    end
endmodule
