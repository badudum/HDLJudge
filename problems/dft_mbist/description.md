Embedded memories are too big and too dense to test with scan. They carry their own
**memory BIST** controller that runs a **March algorithm**: a sequence of elements, each
walking the whole address space in a fixed direction and doing a fixed read/write pattern at
every address.

**March C-** (10N operations) detects stuck-at, transition, coupling and address-decoder faults:

```
M0: ⇕ (w0)
M1: ⇑ (r0, w1)      ascending:  address 0 → 15
M2: ⇑ (r1, w0)
M3: ⇓ (r0, w1)      descending: address 15 → 0
M4: ⇓ (r1, w0)
M5: ⇕ (r0)
```

`rX` means "read and expect X" and `wX` means "write X" (X = all zeros / all ones for our 4-bit words).

The hidden testbench plays the memory. It runs your BIST on a good memory and on memories with
injected faults: stuck-at-0, stuck-at-1, a transition fault, an inversion coupling fault and
an address-decoder fault. It checks that `fail` is correct every time.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `clk`, `rst`, `start` | input | 1 |
| `mem_rdata` | input | 4 (asynchronous read of `mem[mem_addr]`) |
| `mem_addr` | output | 4 |
| `mem_we` | output | 1 |
| `mem_wdata` | output | 4 |
| `busy`, `done`, `fail` | output | 1 |
