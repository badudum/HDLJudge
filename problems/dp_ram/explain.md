### How it works

A true dual-port RAM has two complete ports, each able to read and write every cycle. FPGA block
RAMs support this natively. Two issues need a specification:

- **Read-during-write** on the same port: read-first returns the old contents.
- **Write collision** (both ports write the same address): the result is undefined in real BRAMs. Here port A wins,
  so the model is deterministic.

### Watch out for
- Both reads see the contents from **before** this edge's writes.
- Order the writes so A's assignment comes last (the last nonblocking assignment wins).
