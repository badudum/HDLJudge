`timescale 1ns/1ps
module tb;
    initial begin
        automatic axi_burst it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[3];
        string first[3];
        string key, msg;
        bit ok;
        int bytes, near;
        for (int n = 0; n < 200; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%h/%0d/%0d", it.addr, it.len, it.size);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (it.len > 15 || it.size > 2) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (it.size <= 2 && (it.addr % (1 << it.size)) != 0) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            ok = 1'b1;
            begin
                bytes = (it.len + 1) * (1 << it.size);
                if (it.size <= 2 && it.len <= 15 && (it.addr % 4096) + bytes > 4096) ok = 0;
            end
            if (!ok) begin nbad[2]++; if (first[2] == "") first[2] = key; end
            if (it.size <= 2 && it.len <= 15 && (it.addr % 4096) + (it.len + 1) * (1 << it.size) > 4096 - 64) near++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 200 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: len and size in range -- e.g. %0s (%0d of 200 results)", first[0], nbad[0]);
        else $display("PASS: len and size in range");
        if (nbad[1]) $display("FAIL: address aligned to the beat size -- e.g. %0s (%0d of 200 results)", first[1], nbad[1]);
        else $display("PASS: address aligned to the beat size");
        if (nbad[2]) $display("FAIL: burst does not cross a 4 KB boundary -- e.g. %0s (%0d of 200 results)", first[2], nbad[2]);
        else $display("PASS: burst does not cross a 4 KB boundary");
        ok = 1'b1; msg = "";
        begin
            if (near < 5) begin ok = 0; msg = $sformatf("only %0d of 200 bursts end within 64 bytes of a 4 KB boundary: bias toward the corner", near); end
        end
        if (ok) $display("PASS: some bursts end close to a page boundary"); else $display("FAIL: some bursts end close to a page boundary -- %0s", msg);
        if (distinct < 190) $display("FAIL: randomness -- only %0d distinct results in 200 calls (need 190)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
