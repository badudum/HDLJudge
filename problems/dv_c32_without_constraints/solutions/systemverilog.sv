class perm10;
    rand bit dummy;                // randomize() must succeed
    int perm[10];                 // must hold a random permutation of 0..9 after randomize()

    function void post_randomize();
        foreach (perm[i]) perm[i] = i;
        perm.shuffle();
    endfunction
endclass
