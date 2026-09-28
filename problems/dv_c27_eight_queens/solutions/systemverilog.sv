class queens;
    rand bit [2:0] col[8];     // queen in row r stands in column col[r]

    constraint c { foreach (col[i]) foreach (col[j]) if (i < j) {
                       col[i] != col[j];
                       int'(col[i]) - int'(col[j]) != j - i;
                       int'(col[j]) - int'(col[i]) != j - i; } }
endclass
