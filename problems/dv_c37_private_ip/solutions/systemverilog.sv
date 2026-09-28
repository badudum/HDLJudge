class ip_addr;
    rand bit [7:0] o[4];     // o[0].o[1].o[2].o[3]

    constraint c_private {
        o[0] == 10 || (o[0] == 172 && o[1] inside {[16:31]}) || (o[0] == 192 && o[1] == 168);
    }
    constraint c_host { !(o[3] inside {0, 255}); }
endclass
