A narrow bus carries wide transactions: each 32-bit word goes out as four byte-wide beats. The
driver must obey the handshake, mark the final beat, and keep the bus busy every cycle.

### Provided types (compiled before your code)

```systemverilog
interface beat_if (input logic clk);
    logic       valid;
    logic       last;
    logic [7:0] data;
    logic       ready;
endinterface
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

