class ooo_scoreboard;
    int n_match, n_mismatch, n_missing, n_unexpected;
    txn exp_by_id[int];        // outstanding expected results
    txn act_by_id[int];        // results that arrived before their expected

    function void add_expected(txn t);
        if (act_by_id.exists(t.id)) begin
            compare(t, act_by_id[t.id]);
            act_by_id.delete(t.id);
        end else
            exp_by_id[t.id] = t;
    endfunction

    function void add_actual(txn t);
        if (exp_by_id.exists(t.id)) begin
            compare(exp_by_id[t.id], t);
            exp_by_id.delete(t.id);
        end else
            act_by_id[t.id] = t;
    endfunction

    function void compare(txn e, txn a);
        if (e.data == a.data) n_match++;
        else                  n_mismatch++;
    endfunction

    function void final_check();
        n_missing    = exp_by_id.size();
        n_unexpected = act_by_id.size();
    endfunction
endclass
