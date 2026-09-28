### How it works

Mutation testing measures how good a testbench is. Your testbench runs against the correct ALU (it must stay silent)
and against buggy copies, each with one small change. A testbench "kills" a mutant when it reports an error.

A strong ALU testbench has three parts:
1. a **reference model** in the testbench (a task that computes y and every flag);
2. **directed corners**: 0, 1, 0x7F, 0x80, 0xFF for every operation, every shift amount 0 … 7, and signed extremes;
3. **random** stimulus on top.

### Watch out for
- Check every output (y, carry, zero, neg), and do it every time.
- Report with `$error` and end with `$finish`.
