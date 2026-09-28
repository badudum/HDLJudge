class interleave;
    rand bit [7:0] a[6];
    rand bit [7:0] b[6];

    constraint c { foreach (a[i]) { a[i] < b[i]; if (i < 5) b[i] < a[i+1]; } }
endclass
