**Built-in self-test** can't store every expected response on chip. Instead, responses are
compressed into a short **signature** by a **MISR**, a linear-feedback shift register that
also XORs in a new data word each cycle. At the end, the signature is compared against a
known-good (golden) value.

```
          ┌──────────── feedback (sig[7] · 0x1D) ─────────────┐
          ▼                                                    │
 din ──▶ (⊕) ◀── {sig[6:0], 0} ◀── sig register ──▶ sig[7] ────┘
```

```
sig_next = ({sig[6:0], 1'b0} ^ (sig[7] ? 8'h1D : 8'h00)) ^ din
```

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `en` | input | 1 |
| `din`, `golden` | input | 8 |
| `sig` | output | 8 |
| `pass` | output | 1 |
