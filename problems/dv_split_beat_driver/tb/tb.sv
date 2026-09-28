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
    int ready_mode = 0;       // 0 random, 1 always ready
    bit [7:0] beats[$];
    bit       lasts[$];
    int stall_err = 0, xerr = 0;
    string stall_msg = "", xmsg = "";
    logic pv = 0, pr = 0, pl;
    logic [7:0] pd;

    always @(posedge clk) begin
        if (vif.valid === 1'b1 && vif.ready) begin beats.push_back(vif.data); lasts.push_back(vif.last); end
        if (pv && !pr && (vif.valid !== 1'b1 || vif.data !== pd || vif.last !== pl)) begin
            if (stall_err == 0) stall_msg = $sformatf("t=%0t: valid/data/last changed while ready was low", $time);
            stall_err++;
        end
        if (vif.valid === 1'bx || (vif.valid === 1'b1 && ($isunknown(vif.data) || $isunknown(vif.last)))) begin
            if (xerr == 0) xmsg = $sformatf("t=%0t: X on valid/data/last", $time);
            xerr++;
        end
        pv = vif.valid === 1'b1; pr = vif.ready; pd = vif.data; pl = vif.last;
        vif.ready <= ready_mode == 1 ? 1'b1 : ($urandom % 3 != 0);
    end

    task automatic main();
        beat_driver drv;
        bit [31:0] words[$];
        int t0, t1;
        vif.ready = 0;
        drv = new(vif);
        repeat (2) @(posedge clk);
        for (int i = 0; i < 150; i++) begin
            bit [31:0] w = $urandom;
            words.push_back(w);
            drv.drive(w);
        end
        repeat (4) @(posedge clk);
        begin
            bit ok = beats.size() == 600; string d = $sformatf("%0d beats transferred, expected 600", beats.size());
            for (int i = 0; ok && i < 150; i++)
                for (int j = 0; j < 4; j++)
                    if (beats[4 * i + j] != words[i][8 * j +: 8]) begin
                        ok = 0; d = $sformatf("word #%0d (0x%08h) beat %0d: 0x%02h, expected 0x%02h", i, words[i], j, beats[4 * i + j], words[i][8 * j +: 8]);
                        break;
                    end
            hwlc_results::check("sends 4 beats per word, LSB first", ok, d);
            ok = 1; d = "";
            for (int i = 0; ok && i < beats.size(); i++)
                if (lasts[i] != (i % 4 == 3)) begin ok = 0; d = $sformatf("beat #%0d: last = %0d", i, lasts[i]); end
            hwlc_results::check("last marks the 4th beat only", ok, d);
        end
        hwlc_results::check("holds valid, data and last while stalled", stall_err == 0, stall_msg);
        hwlc_results::check("no X on the bus", xerr == 0, xmsg);
        // throughput: with ready always high, beats must be back-to-back
        ready_mode = 1;
        @(posedge clk);
        beats.delete(); lasts.delete();
        t0 = $time;
        for (int i = 0; i < 25; i++) drv.drive($urandom);
        t1 = $time;
        repeat (3) @(posedge clk);
        hwlc_results::check("back-to-back beats at full throughput", beats.size() == 100 && (t1 - t0) <= 102 * 10,
            $sformatf("25 words (100 beats) took %0d cycles with ready always 1 (limit 102)", (t1 - t0) / 10));
        hwlc_results::report();
        $finish;
    endtask
    initial main();
endmodule
