class row_max;
    rand bit [7:0] m[4][4];

    rand bit [7:0] mx[4];
    constraint c_bound { foreach (m[i, j]) m[i][j] <= mx[i]; }
    constraint c_hit   { foreach (mx[i]) m[i][0] == mx[i] || m[i][1] == mx[i] || m[i][2] == mx[i] || m[i][3] == mx[i]; }
    constraint c_order { foreach (mx[i]) if (i > 0) mx[i] > mx[i-1]; }
endclass
