class beat_monitor;
    virtual beat_if vif;
    msg msgs[$];
    int n_withdrawn;

    function new(virtual beat_if vif); this.vif = vif; endfunction

    task run();
        msg  cur = new();
        bit  pending = 0;          // valid && !ready at the previous edge
        forever begin
            @(posedge vif.clk);
            if (pending && vif.valid !== 1'b1) n_withdrawn++;
            if (vif.valid === 1'b1 && vif.ready === 1'b1) begin
                cur.bytes.push_back(vif.data);
                if (vif.last) begin
                    msgs.push_back(cur);
                    cur = new();
                end
            end
            pending = (vif.valid === 1'b1) && (vif.ready !== 1'b1);
        end
    endtask
endclass
