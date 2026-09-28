class popc_uniform;
    rand bit [7:0] v;

    int k;                                  // bit count for this call, drawn uniformly first
    function void pre_randomize();
        k = $urandom_range(0, 8);
    endfunction
    constraint c_pop { $countones(v) == k; }
endclass
