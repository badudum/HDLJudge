class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)
    uvm_analysis_export #(pkt) exp_export, act_export;
    uvm_tlm_analysis_fifo #(pkt) exp_fifo, act_fifo;
    int n_match, n_mismatch, leftover;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        exp_export = new("exp_export", this);
        act_export = new("act_export", this);
        exp_fifo   = new("exp_fifo", this);
        act_fifo   = new("act_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        exp_export.connect(exp_fifo.analysis_export);
        act_export.connect(act_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        pkt e, a;
        forever begin
            act_fifo.get(a);            // wait for the DUT...
            exp_fifo.get(e);            // ...then pair it with the oldest expected packet
            if (e.id == a.id && e.payload == a.payload) n_match++;
            else begin
                n_mismatch++;
                `uvm_error("SB", $sformatf("expected %s, got %s", e.convert2string(), a.convert2string()))
            end
        end
    endtask

    function void check_phase(uvm_phase phase);
        leftover = exp_fifo.used();
        if (leftover != 0) `uvm_error("SB", $sformatf("%0d expected packets never arrived", leftover))
    endfunction
endclass
