A monitor for a byte-oriented framed protocol: frames start with the marker `AB CD` and end
with `CA FE`, over a stream with idle cycles and garbage between frames. Getting the corner
cases right (split markers, marker bytes inside payloads, runaway frames) is the whole job.

### Provided types (compiled before your code)

```systemverilog
interface byte_if (input logic clk);
    logic       valid;
    logic [7:0] data;
endinterface

class frame;
    bit [7:0] payload[$];
endclass
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|

