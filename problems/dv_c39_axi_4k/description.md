AXI forbids bursts that cross a 4 KB boundary (a slave's address region can end there). Generate legal bursts, and deliberately bias them toward the boundary, where the bugs live.

### Class to complete

```systemverilog
class axi_burst;
    rand bit [31:0] addr;
    rand bit [31:0] len;     // beats - 1 (0..15)
    rand bit [31:0] size;    // bytes per beat = 1 << size (0..2)
    // constraints …
endclass
```
