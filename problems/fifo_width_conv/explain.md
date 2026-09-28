### How it works

An upsizer collects narrow beats into wide words. Here four bytes are packed little-endian: the first
byte goes to bits 7:0, the fourth to bits 31:24. The input side may accept a byte when the output register is free
or is being emptied in this cycle, the same rule as a pipeline register:

```
in_ready = !out_valid || out_ready
```

### Watch out for
- When the 4th byte is accepted, the word register loads `{in_data, acc}` in the same edge.
- A new word can start collecting while the previous one waits on the output.
