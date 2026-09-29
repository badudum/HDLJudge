class invert_callback extends my_callback;
    function new(string name = "invert_callback"); super.new(name); endfunction

    // TODO: override pre_drive so it inverts every bit of item.data
    //       (item.data = ~item.data;) before the driver sends it.
endclass
