Out-of-order completion is normal for memory controllers, interconnects with multiple slaves,
and tagged buses. The scoreboard must pair each result with its request by **tag**, not by
arrival order.

### Provided types (compiled before your code)

```systemverilog
class txn;
    int        id;
    bit [31:0] data;
    function new(int id = 0, bit [31:0] data = 0); this.id = id; this.data = data; endfunction
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

