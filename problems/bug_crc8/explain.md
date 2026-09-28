### How it works

Debug it like a reference-model mismatch. Compute the CRC of a short known input by hand, or trust the
standard check value 0xF4 for "123456789", and compare the first byte's result. Then test the control
signals one at a time, and especially their combinations: `init` and `valid` on the same edge is exactly the
start of a new packet.

### Watch out for
- The bugs may be in the datapath or in the control priority: check both.
- Keep the architecture: the fix is small.
