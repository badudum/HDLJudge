class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)
    uvm_analysis_export #(pkt) exp_export, act_export;
    int n_match, n_mismatch, leftover;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    // TODO: build_phase, connect_phase, run_phase, check_phase
endclass
