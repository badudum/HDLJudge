class unique3d;
    rand bit [5:0] cube[3][3][3];

    constraint c_unique {
        foreach (cube[a, b, c]) foreach (cube[d, e, f])
            if (a * 9 + b * 3 + c < d * 9 + e * 3 + f) cube[a][b][c] != cube[d][e][f];
    }
endclass
