class axi_burst;
    rand bit [31:0] addr;
    rand bit [31:0] len;     // beats - 1 (0..15)
    rand bit [31:0] size;    // bytes per beat = 1 << size (0..2)

    rand bit near_edge;
    constraint c_range { len <= 15; size <= 2; }
    constraint c_align { (size == 1) -> addr[0] == 0; (size == 2) -> addr[1:0] == 2'b00; }
    constraint c_4k {
        (size == 0) -> ({20'd0, addr[11:0]} + len + 1 <= 4096);
        (size == 1) -> ({20'd0, addr[11:0]} + 2 * (len + 1) <= 4096);
        (size == 2) -> ({20'd0, addr[11:0]} + 4 * (len + 1) <= 4096);
    }
    constraint c_corner { near_edge dist { 1 := 1, 0 := 3 }; near_edge -> addr[11:0] >= 12'd3968; }
endclass
