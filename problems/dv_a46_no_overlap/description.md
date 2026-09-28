Two masters share a resource through grant signals. The grants must be **mutually exclusive**,
and a handover from one master to the other needs **one idle cycle** in between:

```
gnt_a  ‾‾‾‾\________
gnt_b  ________/‾‾‾‾   one idle cycle between them
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `gnt_a` | input | 1 |
| `gnt_b` | input | 1 |
