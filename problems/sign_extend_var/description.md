Sign-extend a field whose width is only known at run time, as in instruction decoders with several immediate formats. The naive version is a 16-way mux, and the trick is two operations.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `x` | input | 16 |
| `n` | input | 4 |
| `y` | output | 16 |
