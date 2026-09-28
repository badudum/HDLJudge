class router_scoreboard;
    int n_match, n_misroute, n_order, n_corrupt, n_missing, n_unknown;
    pkt exp_q[4][$];

    function void add_input(pkt p);
        exp_q[p.dest].push_back(p);
    endfunction

    function void add_output(int port, pkt p);
        // find the packet by uid on any port
        for (int d = 0; d < 4; d++)
            foreach (exp_q[d][i])
                if (exp_q[d][i].uid == p.uid) begin
                    if (d != port)                                n_misroute++;
                    else if (exp_q[d][i].payload != p.payload)    n_corrupt++;
                    else if (i != 0)                              n_order++;
                    else                                          n_match++;
                    exp_q[d].delete(i);
                    return;
                end
        n_unknown++;
    endfunction

    function void final_check();
        n_missing = 0;
        for (int d = 0; d < 4; d++) n_missing += exp_q[d].size();
    endfunction
endclass
