class framing_monitor;
    virtual byte_if vif;
    frame frames[$];
    int   n_aborted;

    function new(virtual byte_if vif); this.vif = vif; endfunction

    task run();
        forever begin
            @(posedge vif.clk);
            // TODO
        end
    endtask
endclass
