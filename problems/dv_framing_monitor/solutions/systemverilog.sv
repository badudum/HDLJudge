class framing_monitor;
    virtual byte_if vif;
    frame frames[$];
    int   n_aborted;

    function new(virtual byte_if vif); this.vif = vif; endfunction

    task run();
        bit       in_frame = 0;
        bit [7:0] prev = 0;        // previous valid byte
        bit       have_prev = 0;
        frame     cur;
        forever begin
            @(posedge vif.clk);
            if (vif.valid !== 1'b1) continue;
            if (!in_frame) begin
                if (have_prev && prev == 8'hAB && vif.data == 8'hCD) begin
                    in_frame = 1; cur = new();
                    have_prev = 0;
                    continue;
                end
            end else begin
                if (have_prev && prev == 8'hCA && vif.data == 8'hFE) begin
                    frames.push_back(cur);                  // CA was the trailer, not payload
                    in_frame = 0; have_prev = 0;
                    continue;
                end
                if (have_prev) cur.payload.push_back(prev);  // prev is now known to be payload
                if (cur.payload.size() > 32) begin
                    n_aborted++; in_frame = 0; have_prev = 0;
                    continue;
                end
            end
            prev = vif.data; have_prev = 1;
        end
    endtask
endclass
