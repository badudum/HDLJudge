Gray-to-binary conversion looks inherently serial, since each bit depends on all higher bits. Recognize it as a prefix XOR and meet a log-depth budget.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `g` | input | 32 |
| `b` | output | 32 |
