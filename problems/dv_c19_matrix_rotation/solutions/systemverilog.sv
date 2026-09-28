class rotated;
    rand bit [3:0] a[3][3];
    rand bit [3:0] b[3][3];

    constraint c_rot  { foreach (b[i, j]) b[i][j] == a[2 - j][i]; }
    constraint c_uniq { foreach (a[i, j]) foreach (a[k, l]) if (i * 3 + j < k * 3 + l) a[i][j] != a[k][l]; }
endclass
