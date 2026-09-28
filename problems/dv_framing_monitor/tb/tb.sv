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
    byte_if vif (clk);
    bit [7:0] stream[$];
    frame exp_frames[$];
    int exp_aborted = 0;

    function automatic bit [7:0] noise();
        bit [7:0] b;
        do b = $urandom; while (b == 8'hAB);
        return b;
    endfunction

    function automatic void add_frame(int len, bit abort);
        frame f = new();
        stream.push_back(8'hAB); stream.push_back(8'hCD);
        for (int i = 0; i < len; i++) begin
            bit [7:0] b;
            case ($urandom % 8)
                0: b = 8'hCA;                                   // lone CA is payload
                1: b = 8'hAB;
                2: b = 8'hCD;
                default: b = $urandom;
            endcase
            if (b == 8'hFE && stream[$] == 8'hCA) b = 8'h00;    // never CA FE inside a payload
            stream.push_back(b);
            f.payload.push_back(b);
        end
        if (abort) begin
            for (int i = 0; i < 40; i++) begin
                bit [7:0] b = noise();
                if (b == 8'hFE && stream[$] == 8'hCA) b = 8'h01;
                stream.push_back(b);
            end
            exp_aborted++;
        end else begin
            stream.push_back(8'hCA); stream.push_back(8'hFE);
            exp_frames.push_back(f);
        end
    endfunction

    task automatic main();
        framing_monitor mon;
        int k;
        vif.valid = 0; vif.data = 0;
        // stream: noise, frames, noise, an aborted frame, AB AB CD, ...
        for (int i = 0; i < 5; i++) stream.push_back(noise());
        add_frame(4, 0);
        add_frame(0, 0);
        stream.push_back(8'hAB);                 // AB AB CD: the header is the second AB
        add_frame(3, 0);
        for (k = 0; k < 60; k++) begin
            for (int i = 0; i < $urandom % 4; i++) stream.push_back(noise());
            add_frame($urandom % 33, ($urandom % 12) == 0);
        end
        add_frame(32, 0);
        mon = new(vif);
        fork mon.run(); join_none
        foreach (stream[i]) begin
            while ($urandom % 4 == 0) begin @(negedge clk); vif.valid = 0; vif.data = $urandom; end
            @(negedge clk);
            vif.valid = 1; vif.data = stream[i];
        end
        @(negedge clk) vif.valid = 0;
        repeat (5) @(negedge clk);

        hwlc_results::check("publishes every frame", mon.frames.size() == exp_frames.size(),
            $sformatf("%0d frames published, expected %0d", mon.frames.size(), exp_frames.size()));
        begin
            bit ok = 1; string d = "";
            for (int i = 0; ok && i < mon.frames.size() && i < exp_frames.size(); i++)
                if (mon.frames[i].payload != exp_frames[i].payload) begin
                    ok = 0;
                    d = $sformatf("frame #%0d: payload of %0d bytes differs from the expected %0d bytes", i, mon.frames[i].payload.size(), exp_frames[i].payload.size());
                    for (int j = 0; j < mon.frames[i].payload.size() && j < exp_frames[i].payload.size(); j++)
                        if (mon.frames[i].payload[j] != exp_frames[i].payload[j]) begin
                            d = $sformatf("frame #%0d byte %0d: 0x%02h, expected 0x%02h", i, j, mon.frames[i].payload[j], exp_frames[i].payload[j]);
                            break;
                        end
                end
            hwlc_results::check("payloads exclude header and trailer", ok, d);
            ok = 1; d = "";
            for (int i = 0; ok && i < 3 && i < mon.frames.size(); i++)
                if (mon.frames[i].payload != exp_frames[i].payload) begin ok = 0; d = $sformatf("frame #%0d (empty frame / AB AB CD case) wrong", i); end
            hwlc_results::check("empty frames and repeated AB", ok, d);
        end
        hwlc_results::check("aborts frames longer than 32 bytes", mon.n_aborted == exp_aborted, $sformatf("n_aborted = %0d, expected %0d", mon.n_aborted, exp_aborted));
        hwlc_results::report();
        $finish;
    endtask
    initial main();
endmodule
