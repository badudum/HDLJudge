class low_match;
    rand bit [7:0] a;
    rand bit [7:0] b;

    rand bit same;
    constraint c_same { same dist {1 := 5, 0 := 95}; }
    constraint c_link { same == (a[3:0] == b[3:0]); }
endclass
