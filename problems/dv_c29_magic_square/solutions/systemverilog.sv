class magic3;
    rand bit [3:0] sq[3][3];

    constraint c_val  { foreach (sq[i, j]) sq[i][j] inside {[1:9]}; }
    constraint c_uniq { foreach (sq[i, j]) foreach (sq[k, l]) if (i * 3 + j < k * 3 + l) sq[i][j] != sq[k][l]; }
    constraint c_rows { foreach (sq[i]) int'(sq[i][0]) + sq[i][1] + sq[i][2] == 15; }
    constraint c_cols { foreach (sq[0][j]) int'(sq[0][j]) + sq[1][j] + sq[2][j] == 15; }
    constraint c_diag { int'(sq[0][0]) + sq[1][1] + sq[2][2] == 15;
                        int'(sq[0][2]) + sq[1][1] + sq[2][0] == 15; }
endclass
