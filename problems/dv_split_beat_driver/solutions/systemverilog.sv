class beat_driver;
    virtual beat_if vif;

    function new(virtual beat_if vif);
        this.vif = vif;
        vif.valid = 1'b0;
        vif.last  = 1'b0;
        vif.data  = 8'h00;
    endfunction

    // Called back-to-back by the test: drive one 32-bit word as 4 byte beats.
    task drive(bit [31:0] w);
        for (int i = 0; i < 4; i++) begin
            vif.valid <= 1'b1;
            vif.data  <= w[8 * i +: 8];
            vif.last  <= (i == 3);
            do @(posedge vif.clk); while (!vif.ready);
        end
        vif.valid <= 1'b0;
        vif.last  <= 1'b0;
    endtask
endclass
