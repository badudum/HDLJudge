Adders sit on the critical path of nearly every datapath. A **ripple-carry adder** is small,
but the carry must travel through every bit, so its depth grows linearly with the width.
**Parallel-prefix adders** (Kogge-Stone, Brent-Kung, Sklansky, …) compute all carries in
*logarithmic* depth.

Build a 16-bit adder with carry-in whose critical path fits in **12 logic levels**. Simply
writing `a + b + cin` isn't enough: the generic adder the synthesizer builds is 16 levels deep.
You have to design the carry network yourself.

```
ripple:      c1 ← c0,  c2 ← c1,  …,  c16 ← c15              (16 carry stages)
Kogge-Stone: distance 1 → distance 2 → distance 4 → distance 8  (4 prefix stages)
```

The Synthesis stage shows the depth of your design and its critical path, so you can
iterate like a real timing closure loop.

### Interface

| Port   | Direction | Width |
|--------|-----------|-------|
| `a`    | input  | 16 |
| `b`    | input  | 16 |
| `cin`  | input  | 1 |
| `s`    | output | 16 |
| `cout` | output | 1 |
