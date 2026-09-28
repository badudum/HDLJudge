class sudoku6;
    rand bit [2:0] g[6][6];

    constraint c_val  { foreach (g[i, j]) g[i][j] inside {[1:6]}; }
    constraint c_diff { foreach (g[i, j]) foreach (g[k, l])
                            if ((i * 6 + j) < (k * 6 + l) && (i == k || j == l || (i / 2 == k / 2 && j / 3 == l / 3)))
                                g[i][j] != g[k][l]; }
    constraint c_clue { g[0][0] == 1; g[5][5] == 6; }
endclass
