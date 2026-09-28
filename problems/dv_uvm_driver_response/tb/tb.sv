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

module mul_dut (input logic clk, input logic req, input logic [7:0] a, input logic [7:0] b,
                output logic busy, output logic done, output logic [15:0] result);
    logic [2:0] cnt;
    logic [7:0] lfsr = 8'hA5;
    logic [15:0] r;
    initial begin busy = 0; done = 0; result = 0; end
    always @(posedge clk) begin
        lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        done <= 1'b0;
        if (req && !busy) begin
            busy <= 1'b1; r <= a * b; cnt <= 3'd1 + (lfsr[2:0] % 3'd6);
        end else if (busy) begin
            if (cnt == 3'd1) begin busy <= 1'b0; done <= 1'b1; result <= r; end
            cnt <= cnt - 3'd1;
        end
    end
endmodule

class hwlc_seq extends uvm_sequence #(mul_item);
    `uvm_object_utils(hwlc_seq)
    int n = 30;
    bit hi;               // this sequence uses operands with a[7] = hi
    int got = 0;
    function new(string name = "hwlc_seq"); super.new(name); endfunction
    task body();
        mul_item it, rsp;
        repeat (n) begin
            it = mul_item::type_id::create("it");
            start_item(it);
            it.a = {hi, 7'($urandom)}; it.b = 8'($urandom);
            finish_item(it);
            get_response(rsp);
            got++;
            hwlc_results::check("responses carry the DUT result", rsp != null && rsp.result == it.a * it.b,
                rsp == null ? "get_response returned null" : $sformatf("request a=%0d b=%0d: response result=%0d, expected %0d", it.a, it.b, rsp.result, it.a * it.b));
            if (rsp != null)
                hwlc_results::check("responses are routed to the right sequence", rsp.get_transaction_id() == it.get_transaction_id(),
                    $sformatf("response transaction id %0d does not match request id %0d (call rsp.set_id_info(req))", rsp.get_transaction_id(), it.get_transaction_id()));
        end
    endtask
endclass

class hwlc_test extends uvm_test;
    `uvm_component_utils(hwlc_test)
    mul_driver drv;
    uvm_sequencer #(mul_item) sqr;
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    function void build_phase(uvm_phase phase);
        drv = mul_driver::type_id::create("drv", this);
        sqr = uvm_sequencer#(mul_item)::type_id::create("sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
    task run_phase(uvm_phase phase);
        hwlc_seq s1, s2, s3;
        phase.raise_objection(this);
        s1 = hwlc_seq::type_id::create("s1");
        s2 = hwlc_seq::type_id::create("s2"); s2.hi = 1;
        s3 = hwlc_seq::type_id::create("s3"); s3.n = 10;
        fork
            begin
                s3.start(sqr);
                hwlc_results::check("one sequence: every request gets a response", s3.got == 10, $sformatf("%0d of 10 responses received", s3.got));
                fork s1.start(sqr); s2.start(sqr); join
                hwlc_results::check("two parallel sequences share the driver", s1.got == 30 && s2.got == 30,
                    $sformatf("%0d + %0d of 30 + 30 responses received", s1.got, s2.got));
            end
            begin
                #200us;
                hwlc_results::check("one sequence: every request gets a response", s3.got == 10, $sformatf("timed out: only %0d of 10 responses received (driver not returning responses?)", s3.got));
                hwlc_results::check("two parallel sequences share the driver", 0, $sformatf("timed out: %0d + %0d of 30 + 30 responses received", s1.got, s2.got));
            end
        join_any
        disable fork;
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        hwlc_results::check("DUT protocol: req only while idle, one cycle long", tb.violations == 0, tb.vmsg);
        hwlc_results::check("responses carry the DUT result", 1);
        hwlc_results::check("responses are routed to the right sequence", 1);
        hwlc_results::report();
    endfunction
endclass

module tb;
    logic clk = 0;
    always #5 clk = ~clk;
    mul_if vif (clk);
    mul_dut dut (.clk(clk), .req(vif.req), .a(vif.a), .b(vif.b), .busy(vif.busy), .done(vif.done), .result(vif.result));
    int violations = 0;
    string vmsg = "";
    logic req_q = 0;
    always @(posedge clk) begin
        if (vif.req === 1'b1 && vif.busy === 1'b1) begin
            if (violations == 0) vmsg = $sformatf("t=%0t: req asserted while busy (or held for more than one cycle)", $time);
            violations++;
        end
        if (vif.req === 1'bx) begin
            if (violations == 0) vmsg = $sformatf("t=%0t: req is X (drive it to 0 when idle)", $time);
            violations++;
        end
    end
    initial begin
        uvm_config_db#(virtual mul_if)::set(null, "*", "vif", vif);
        run_test("hwlc_test");
    end
endmodule
