class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    bus_agent agent;
    bus_sb    sb;
    bus_cov   cov;
    int       has_coverage = 1;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db#(int)::get(this, "", "has_coverage", has_coverage));
        agent = bus_agent::type_id::create("agent", this);
        sb    = bus_sb::type_id::create("sb", this);
        if (has_coverage)
            cov = bus_cov::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent.mon.ap.connect(sb.imp);
        if (cov != null)
            agent.mon.ap.connect(cov.analysis_export);
    endfunction
endclass
