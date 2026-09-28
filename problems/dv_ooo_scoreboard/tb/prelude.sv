class txn;
    int        id;
    bit [31:0] data;
    function new(int id = 0, bit [31:0] data = 0); this.id = id; this.data = data; endfunction
endclass
