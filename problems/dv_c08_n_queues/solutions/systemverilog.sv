class n_queues;
    rand bit [1:0] owner[10];     // queue (0..3) of item i
    int q[4][$];

    constraint c_size {
        owner.sum() with (int'(item == 0)) inside {[2:3]};
        owner.sum() with (int'(item == 1)) inside {[2:3]};
        owner.sum() with (int'(item == 2)) inside {[2:3]};
        owner.sum() with (int'(item == 3)) inside {[2:3]};
    }
    function void post_randomize();
        foreach (q[k]) q[k].delete();
        foreach (owner[i]) q[owner[i]].push_back(i);
    endfunction
endclass
