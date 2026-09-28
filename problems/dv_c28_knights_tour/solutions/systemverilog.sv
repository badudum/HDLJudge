class knight_tour;
    rand bit [1:0] r[12];    // row (0..2) of the k-th square visited
    rand bit [1:0] c[12];    // column (0..3) of the k-th square visited

    constraint c_board { foreach (r[k]) r[k] inside {[0:2]}; }
    constraint c_once  { foreach (r[k]) foreach (r[m]) if (k < m) (r[k] != r[m]) || (c[k] != c[m]); }
    constraint c_move  { foreach (r[k]) if (k > 0) {
        (int'(r[k]) - int'(r[k-1]) inside {-1, 1} && int'(c[k]) - int'(c[k-1]) inside {-2, 2}) ||
        (int'(r[k]) - int'(r[k-1]) inside {-2, 2} && int'(c[k]) - int'(c[k-1]) inside {-1, 1}); } }
endclass
