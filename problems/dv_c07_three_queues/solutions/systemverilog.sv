class three_q;
    rand bit [1:0] owner[12];     // queue (0..2) that item i+1 goes to
    int q[3][$];                 // built in post_randomize()

    constraint c_own  { foreach (owner[i]) owner[i] inside {[0:2]}; }
    constraint c_size {
        owner.sum() with (int'(item == 0)) >= 1;
        owner.sum() with (int'(item == 1)) >= 1;
        owner.sum() with (int'(item == 2)) >= 1;
        owner.sum() with (int'(item == 0)) != owner.sum() with (int'(item == 1));
        owner.sum() with (int'(item == 1)) != owner.sum() with (int'(item == 2));
        owner.sum() with (int'(item == 0)) != owner.sum() with (int'(item == 2));
    }
    function void post_randomize();
        foreach (q[k]) q[k].delete();
        foreach (owner[i]) q[owner[i]].push_back(i + 1);
    endfunction
endclass
