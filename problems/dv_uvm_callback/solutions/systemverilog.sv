class invert_callback extends my_callback;
    function new(string name = "invert_callback"); super.new(name); endfunction

    virtual function void pre_drive(cb_item item);
        item.data = ~item.data;
    endfunction
endclass
