class mem_ops;
    rand bit [5:0] addr[6];
    rand bit [3:0] len[6];     // bytes, 1..8

    constraint c_len  { foreach (len[i]) { len[i] inside {[1:8]}; int'(addr[i]) + len[i] <= 64; } }
    constraint c_free { foreach (addr[i]) foreach (addr[j]) if (i < j)
                            int'(addr[i]) + len[i] <= addr[j] || int'(addr[j]) + len[j] <= addr[i]; }
endclass
