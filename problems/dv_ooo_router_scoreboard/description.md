A scoreboard for a packet router that keeps FIFO order on each output but not across outputs.
One global queue would flag false errors; per-port queues model the real ordering guarantee.

### Provided types (compiled before your code)

```systemverilog
class pkt;
    int        uid;       // unique per packet
    int        dest;      // output port 0..3
    bit [31:0] payload;
    function new(int uid = 0, int dest = 0, bit [31:0] payload = 0);
        this.uid = uid; this.dest = dest; this.payload = payload;
    endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

