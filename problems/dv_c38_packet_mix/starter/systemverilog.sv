class pkt_mix;
    typedef enum bit [1:0] {SMALL, MEDIUM, LARGE} kind_e;
    rand kind_e kind;
    rand bit [7:0] len;

    // Your constraints here

endclass
