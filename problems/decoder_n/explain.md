### How it works

A decoder turns an N-bit number into a one-hot vector of 2ᴺ lines. In Verilog the whole thing is one shift:
`y = en ? (1 << sel) : 0`. For a parameterized width, size the constant correctly: `{{(2**N-1){1'b0}}, 1'b1} << sel`.

### Watch out for
- The judge instantiates N = 5 (32 outputs): make every width depend on N.
