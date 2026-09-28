class pkt;
    int        uid;       // unique per packet
    int        dest;      // output port 0..3
    bit [31:0] payload;
    function new(int uid = 0, int dest = 0, bit [31:0] payload = 0);
        this.uid = uid; this.dest = dest; this.payload = payload;
    endfunction
endclass
