class bin_matrix;
    rand bit m[4][4];

    constraint c_rows { foreach (m[i]) int'(m[i][0]) + int'(m[i][1]) + int'(m[i][2]) + int'(m[i][3]) == 2; }
    constraint c_cols { foreach (m[0][j]) int'(m[0][j]) + int'(m[1][j]) + int'(m[2][j]) + int'(m[3][j]) == 2; }
endclass
