GPUs execute a **warp** of threads in lock-step (SIMT). When a branch condition differs between
threads, the warp **diverges**: the hardware runs the taken path with some lanes masked off,
then the other path with the complementary mask.

For an 8-lane warp, compute the masks needed at a branch:

| Output | Meaning |
|--------|---------|
| `taken`      | active lanes whose condition is true |
| `not_taken`  | active lanes whose condition is false |
| `divergent`  | both paths have at least one lane |
| `first_lane` | lowest-numbered active lane (used for scalar/uniform operations) |
| `any_active` | at least one lane is active |

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `active`, `cond` | input | 8 |
| `taken`, `not_taken` | output | 8 |
| `divergent`, `any_active` | output | 1 |
| `first_lane` | output | 3 |
