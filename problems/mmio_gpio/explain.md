### How it works

A GPIO block is a small register file that software reads and writes over a bus:

| addr | register | access |
|------|----------|--------|
| 0 | OUT | RW, drives the pins |
| 1 | DIR | RW, output enables |
| 2 | IN | RO, synchronized pins |
| 3 | RISE | RW1C, sticky rising-edge flags |

The pins are asynchronous, so they pass through a 2-flop synchronizer before any logic uses them. A third flop
remembers the previous synchronized value for edge detection.

### Watch out for
- Write-1-to-clear: writing 1 clears a flag, writing 0 leaves it. If a new edge arrives in the same cycle, set wins.
- Writes to IN are ignored.
