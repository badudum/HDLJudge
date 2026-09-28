`timescale 1ns/1ps
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

module tb;
    logic clk = 0;
    always #5 clk = ~clk;
    beat_if vif (clk);
    msg exp_msgs[$];
    int exp_withdrawn = 0;

    always @(posedge clk) vif.ready <= ($urandom % 3 != 0);

    // legal driver, with occasional deliberate valid withdrawal (protocol violation)
    task automatic send(msg m);
        foreach (m.bytes[i]) begin
            @(negedge clk);
            vif.valid = 1; vif.data = m.bytes[i]; vif.last = (i == m.bytes.size() - 1);
            @(posedge clk);
            while (!vif.ready) begin
                if ($urandom % 25 == 0) begin
                    // withdraw valid for a cycle while stalled (illegal), then re-offer
                    @(negedge clk); vif.valid = 0; exp_withdrawn++;
                    @(negedge clk); vif.valid = 1;
                    @(posedge clk);
                end else @(posedge clk);
            end
        end
        @(negedge clk);
        vif.valid = 0; vif.last = 0;
        repeat ($urandom % 3) @(negedge clk);
    endtask

    task automatic main();
        beat_monitor mon;
        vif.valid = 0; vif.last = 0; vif.data = 0; vif.ready = 0;
        mon = new(vif);
        fork mon.run(); join_none
        repeat (2) @(posedge clk);
        for (int i = 0; i < 200; i++) begin
            msg m = new();
            int n = 1 + $urandom % 8;
            for (int j = 0; j < n; j++) m.bytes.push_back($urandom);
            exp_msgs.push_back(m);
            send(m);
        end
        repeat (5) @(posedge clk);
        hwlc_results::check("reassembles every message", mon.msgs.size() == exp_msgs.size(),
            $sformatf("%0d messages published, expected %0d", mon.msgs.size(), exp_msgs.size()));
        begin
            bit ok = 1; string d = "";
            for (int i = 0; ok && i < mon.msgs.size() && i < exp_msgs.size(); i++)
                if (mon.msgs[i].bytes != exp_msgs[i].bytes) begin
                    ok = 0; d = $sformatf("message #%0d: %0d bytes published, expected %0d bytes (or different contents)", i, mon.msgs[i].bytes.size(), exp_msgs[i].bytes.size());
                end
            hwlc_results::check("variable-length messages, only transferred beats", ok, d);
            ok = 1; d = "";
            for (int i = 1; ok && i < mon.msgs.size(); i++) if (mon.msgs[i] == mon.msgs[i - 1]) begin ok = 0; d = "the same msg object was published twice: create a new msg per message"; end
            hwlc_results::check("a new object per message", ok, d);
        end
        hwlc_results::check("counts valid withdrawn before ready", mon.n_withdrawn == exp_withdrawn,
            $sformatf("n_withdrawn = %0d, expected %0d", mon.n_withdrawn, exp_withdrawn));
        hwlc_results::report();
        $finish;
    endtask
    initial main();
endmodule
