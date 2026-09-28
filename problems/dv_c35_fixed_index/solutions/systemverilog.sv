class fixed_idx;
    rand bit [7:0] arr[10];

    constraint c { arr[3] == 42; arr[7] == arr[3] + 1; foreach (arr[i]) if (i != 3) arr[i] != 42; }
endclass
