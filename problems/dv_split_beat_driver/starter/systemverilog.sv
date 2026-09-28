class beat_driver;
    virtual beat_if vif;

    function new(virtual beat_if vif);
        this.vif = vif;
        vif.valid = 1'b0;
    endfunction

    task drive(bit [31:0] w);
        // TODO
    endtask
endclass
