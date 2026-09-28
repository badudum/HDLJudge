class even_odd;
    rand bit [7:0] arr[12];

    constraint c_parity { foreach (arr[i]) arr[i][0] == i[0]; }
    constraint c_incr   { foreach (arr[i]) if (i >= 2 && i % 2 == 0) arr[i] > arr[i-2]; }
endclass
