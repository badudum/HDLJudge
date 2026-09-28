class beat_monitor;
    virtual beat_if vif;
    msg msgs[$];
    int n_withdrawn;

    function new(virtual beat_if vif); this.vif = vif; endfunction

    task run();
        forever begin
            @(posedge vif.clk);
            // TODO
        end
    endtask
endclass
