An asynchronous input (a button, a signal from another clock domain) must be **synchronized**
before use: two flip-flops in series give a metastable first stage a full clock period to
settle. The edge detection then works on the clean, synchronized signal.

```
din ──▶[s1]──▶[s2]──┬──────────────▶ level
                    ├──▶[s3]──┐
                    │         ▼
                    └──▶ rise = s2 & ~s3,  fall = ~s2 & s3
```

The current implementation produces **fall** pulses at the wrong moments, and a lint tool
flagged a synchronizer violation. **2 bugs**.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `din` | input | 1 |
| `level`, `rise`, `fall` | output | 1 |
