`timescale 1ns/1ps
module tb;
    initial begin
        automatic ip_addr it = new;
        int fails = 0, distinct = 0;
        int seen[string];
        int nbad[2];
        string first[2];
        string key, msg;
        bit ok;
        int n10, n172, n192;
        for (int n = 0; n < 300; n++) begin
            if (!it.randomize()) begin fails++; continue; end
            key = $sformatf("%0d.%0d.%0d.%0d", it.o[0], it.o[1], it.o[2], it.o[3]);
            if (!seen.exists(key)) begin seen[key] = 1; distinct++; end
            ok = 1'b1;
            begin
                if (!(it.o[0] == 10 || (it.o[0] == 172 && it.o[1] inside {[16:31]}) || (it.o[0] == 192 && it.o[1] == 168))) ok = 0;
            end
            if (!ok) begin nbad[0]++; if (first[0] == "") first[0] = key; end
            ok = 1'b1;
            begin
                if (it.o[3] == 0 || it.o[3] == 255) ok = 0;
            end
            if (!ok) begin nbad[1]++; if (first[1] == "") first[1] = key; end
            if (it.o[0] == 10) n10++; else if (it.o[0] == 172) n172++; else n192++;
        end
        if (fails) $display("FAIL: randomize() succeeds -- %0d of 300 calls failed", fails);
        else $display("PASS: randomize() succeeds");
        if (nbad[0]) $display("FAIL: inside a private range -- e.g. %0s (%0d of 300 results)", first[0], nbad[0]);
        else $display("PASS: inside a private range");
        if (nbad[1]) $display("FAIL: host octet is not 0 or 255 -- e.g. %0s (%0d of 300 results)", first[1], nbad[1]);
        else $display("PASS: host octet is not 0 or 255");
        ok = 1'b1; msg = "";
        begin
            if (n10 == 0 || n172 == 0 || n192 == 0) begin ok = 0; msg = $sformatf("10.x: %0d, 172.16/12: %0d, 192.168/16: %0d", n10, n172, n192); end
        end
        if (ok) $display("PASS: all three private ranges occur"); else $display("FAIL: all three private ranges occur -- %0s", msg);
        if (distinct < 280) $display("FAIL: randomness -- only %0d distinct results in 300 calls (need 280)", distinct);
        else $display("PASS: randomness (%0d distinct results)", distinct);
        $display("TB_DONE");
        $finish;
    end
endmodule
