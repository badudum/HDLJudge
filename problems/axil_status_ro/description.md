A status block: an ID register, a live status word and an event counter, all read-only. Writes must still be answered, with an error response.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `aclk` | input | 1 |
| `aresetn` | input | 1 |
| `awaddr` | input | 8 |
| `awvalid` | input | 1 |
| `awready` | output | 1 |
| `wdata` | input | 32 |
| `wstrb` | input | 4 |
| `wvalid` | input | 1 |
| `wready` | output | 1 |
| `bresp` | output | 2 |
| `bvalid` | output | 1 |
| `bready` | input | 1 |
| `araddr` | input | 8 |
| `arvalid` | input | 1 |
| `arready` | output | 1 |
| `rdata` | output | 32 |
| `rresp` | output | 2 |
| `rvalid` | output | 1 |
| `rready` | input | 1 |
| `status_in` | input | 32 |
| `event_in` | input | 1 |
