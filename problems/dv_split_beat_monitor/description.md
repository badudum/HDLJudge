The receiving side of a split-beat bus: reassemble variable-length messages from byte beats
marked by `last`. As a good monitor should, it also flags a common handshake violation: a source
that withdraws `valid` before the sink accepted the beat.

### Provided types (compiled before your code)

```systemverilog
interface beat_if (input logic clk);
    logic       valid;
    logic       last;
    logic [7:0] data;
    logic       ready;
endinterface

class msg;
    bit [7:0] bytes[$];
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

