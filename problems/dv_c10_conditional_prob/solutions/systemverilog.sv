class cond_prob;
    rand bit       mode;
    rand bit [3:0] len;

    constraint c_mode { mode dist {1 := 70, 0 := 30}; }
    constraint c_len  {
        if (mode) len dist {15 := 50, [8:14] :/ 50};
        else      len inside {[0:7]};
    }
endclass
