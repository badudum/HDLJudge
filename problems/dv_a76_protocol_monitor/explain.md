### How it works

- **Handshake persistence** (per channel): `awvalid && !awready |=> awvalid`, and the same for W and B.
- **Response ordering:** B may only be asserted once an address **and** a data handshake have
  both completed and are still unanswered. Count them in auxiliary code:
  `aw_cnt`, `w_cnt` (incremented on handshakes) and `b_cnt`, then assert
  `bvalid |-> aw_cnt > b_cnt && w_cnt > b_cnt`.

This is what commercial AXI protocol checkers do.

### How the checker is graded

Your module is bound to a replay of short signal traces (the waveforms below show two of them).
Legal traces must produce **no** error, and every violating trace must make at least one assertion
fail. Signals change at falling clock edges, so your properties see stable values at every
rising edge.

### Watch out for
- The handshakes must be complete in **earlier** cycles: a response in the same cycle as the W handshake is illegal.
