class coloring;
    rand bit [1:0] grid[4][4];

    constraint c { foreach (grid[i, j]) { if (j < 3) grid[i][j] != grid[i][j+1];
                                       if (i < 3) grid[i][j] != grid[i+1][j]; } }
endclass
