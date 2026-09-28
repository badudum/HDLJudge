class two_mins;
    rand bit [4:0] a[3][3];
    rand bit [4:0] b[3][3];

    rand bit [4:0] ma, mb;
    constraint c_bound { foreach (a[i, j]) { a[i][j] >= ma; b[i][j] >= mb; } }
    constraint c_hit   { a[0][0] == ma || a[0][1] == ma || a[0][2] == ma || a[1][0] == ma || a[1][1] == ma ||
                         a[1][2] == ma || a[2][0] == ma || a[2][1] == ma || a[2][2] == ma;
                         b[0][0] == mb || b[0][1] == mb || b[0][2] == mb || b[1][0] == mb || b[1][1] == mb ||
                         b[1][2] == mb || b[2][0] == mb || b[2][1] == mb || b[2][2] == mb; }
    constraint c_once  { foreach (a[i, j]) foreach (a[k, l]) if (i * 3 + j < k * 3 + l) {
                             !(a[i][j] == ma && a[k][l] == ma); !(b[i][j] == mb && b[k][l] == mb); } }
    constraint c_order { ma < mb; }
endclass
