### How it works

A 2-bit saturating counter per table entry gives **hysteresis**. A loop branch that is taken 9 times and
then not taken once mispredicts only at the loop exit. With 1-bit history it would also mispredict on the next
entry into the loop.

| counter | meaning | prediction |
|---------|---------|------------|
| 00 | strongly not-taken | NT |
| 01 | weakly not-taken | NT |
| 10 | weakly taken | T |
| 11 | strongly taken | T |

### Watch out for
- Saturate at 0 and 3: never wrap.
- Index with `pc[5:2]`, since instructions are 4-byte aligned.
