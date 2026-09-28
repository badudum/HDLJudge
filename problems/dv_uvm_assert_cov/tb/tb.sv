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
    function new(string name, uvm_component parent); super.new(name, parent); endfunction
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        wait (tb.done);
        phase.drop_objection(this);
    endtask
    function void report_phase(uvm_phase phase);
        uvm_report_server s = uvm_report_server::get_server();
        hwlc_results::check("gnt without req reported as HS_GNT_NO_REQ", s.get_id_count("HS_GNT_NO_REQ") == tb.e_gnt,
            $sformatf("%0d HS_GNT_NO_REQ errors, expected %0d", s.get_id_count("HS_GNT_NO_REQ"), tb.e_gnt));
        hwlc_results::check("req dropped before gnt reported as HS_REQ_DROP", s.get_id_count("HS_REQ_DROP") == tb.e_drop,
            $sformatf("%0d HS_REQ_DROP errors, expected %0d", s.get_id_count("HS_REQ_DROP"), tb.e_drop));
        hwlc_results::check("id change while waiting reported as HS_ID_CHANGE", s.get_id_count("HS_ID_CHANGE") == tb.e_id,
            $sformatf("%0d HS_ID_CHANGE errors, expected %0d", s.get_id_count("HS_ID_CHANGE"), tb.e_id));
        hwlc_results::check("late grant reported as HS_TIMEOUT", s.get_id_count("HS_TIMEOUT") == tb.e_to,
            $sformatf("%0d HS_TIMEOUT errors, expected %0d", s.get_id_count("HS_TIMEOUT"), tb.e_to));
        hwlc_results::check("cover: back-to-back grants", tb.u_sva.cov_b2b == tb.c_b2b,
            $sformatf("cov_b2b = %0d, expected %0d", tb.u_sva.cov_b2b, tb.c_b2b));
        hwlc_results::check("cover: grant at the maximum wait", tb.u_sva.cov_max_wait == tb.c_max,
            $sformatf("cov_max_wait = %0d, expected %0d", tb.u_sva.cov_max_wait, tb.c_max));
        hwlc_results::report();
    endfunction
endclass

module tb;
    logic clk = 0, rst = 1, req = 0, gnt = 0, done = 0;
    logic [3:0] id = 0;
    int k;
    always #5 clk = ~clk;
    hs_sva u_sva (.clk(clk), .rst(rst), .req(req), .gnt(gnt), .id(id));

    // reference model of the expected assertion failures and cover hits
    int e_gnt = 0, e_drop = 0, e_id = 0, e_to = 0, c_b2b = 0, c_max = 0;
    logic [7:0] rq = 0, gq = 0;             // history, bit 0 = current cycle
    logic [3:0] idq = 0;
    always @(posedge clk) begin
        rq = {rq[6:0], req}; gq = {gq[6:0], gnt};
        if (!rst) begin
            if (gnt && !req) e_gnt++;
            if (rq[1] && !gq[1] && !req) e_drop++;
            if (rq[1] && !gq[1] && id != idq) e_id++;
            if (rq[5] && !rq[6] && !(gq[4] || gq[3] || gq[2] || gq[1])) e_to++;
            if (gq[1] && gnt) c_b2b++;
            if (rq[4] && !rq[5] && gnt) c_max++;
        end
        idq = id;
    end

    task automatic cyc(input logic r, input logic g); @(negedge clk); req = r; gnt = g; endtask
    task automatic xact(input int wait_cycles, input logic keep);   // legal transaction
        id = $urandom;
        cyc(1, 0);
        repeat (wait_cycles - 1) cyc(1, 0);
        cyc(1, 1);
        if (!keep) cyc(0, 0);
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst = 0;
        repeat (2) cyc(0, 0);
        for (int i = 0; i < 300; i++) begin
            k = $urandom % 20;
            if (k == 0)      begin cyc(0, 1); cyc(0, 0); end                           // gnt without req
            else if (k == 1) begin id = $urandom; cyc(1, 0); cyc(1, 0); cyc(0, 0); repeat (5) cyc(0, 0); end   // req drops early
            else if (k == 2) begin id = 1; cyc(1, 0); @(negedge clk); id = 2; cyc(1, 1); cyc(0, 0); end       // id changes
            else if (k == 3) begin id = $urandom; cyc(1, 0); repeat (5) cyc(1, 0); cyc(1, 1); cyc(0, 0); end  // grant after 6
            else if (k == 4) begin id = $urandom; cyc(1, 0); cyc(1, 1); cyc(1, 1); cyc(0, 0); end   // back-to-back grants
            else             xact(1 + $urandom % 4, 0);
            if ($urandom % 3 == 0) cyc(0, 0);
        end
        repeat (8) cyc(0, 0);
        done = 1;
    end
    initial run_test("hwlc_test");
endmodule
