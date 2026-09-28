class pkt_mix;
    typedef enum bit [1:0] {SMALL, MEDIUM, LARGE} kind_e;
    rand kind_e kind;
    rand bit [7:0] len;

    constraint c_mix { kind dist { SMALL := 6, MEDIUM := 3, LARGE := 1 }; }
    constraint c_len {
        kind == SMALL  -> len inside {[1:16]};
        kind == MEDIUM -> len inside {[17:128]};
        kind == LARGE  -> len inside {[129:255]};
    }
endclass
