Sliding-window extrema are a staple of signal processing (envelope detection, peak hold, morphological filters). Maintain the min and max of the last 8 samples.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk` | input | 1 |
| `rst` | input | 1 |
| `valid` | input | 1 |
| `din` | input | 8 |
| `wmin` | output | 8 |
| `wmax` | output | 8 |
