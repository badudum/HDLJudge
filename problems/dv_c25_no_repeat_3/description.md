A tighter version of the history-window constraint: only five values, and none may repeat within four draws. Round-robin ID allocators and tag pools need exactly this stimulus.

### Class to complete

```systemverilog
class draws5;
    rand bit [2:0] val;
    // constraints …
endclass
```
