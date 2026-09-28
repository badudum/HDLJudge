Compute an absolute value without any branch or comparison. The same trick makes software faster (no mispredicted branches) and makes hardware smaller (no mux).

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x` | input | 8 |
| `y` | output | 8 |
