Generate non-overlapping buffers, e.g. DMA descriptors that must not step on each other.

### Class to complete

```systemverilog
class mem_ops;
    rand bit [5:0] addr[6];
    rand bit [3:0] len[6];     // bytes, 1..8
    // constraints …
endclass
```
