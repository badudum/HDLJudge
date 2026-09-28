### How it works

A CRC is the remainder of a polynomial division over GF(2), where addition is XOR. The bit-serial
form is an LFSR: shift the register left one bit per data bit, and if the bit shifted out XOR the
data bit is 1, XOR in the polynomial (0x07 for x⁸ + x² + x + 1).

Processing a whole byte per cycle is the same loop unrolled 8 times. A `for` loop inside the
combinational block does exactly that, and synthesis turns it into an XOR network.

### Watch out for
- The loop variable is a *blocking* temporary: compute the new CRC with blocking assignments, then register it once.
- Process the byte MSB first (bit 7 → bit 0). The check value of "123456789" is 0xF4.
