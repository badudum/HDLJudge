### How it works

A discrete-time integrator accumulates its input: y[n] = y[n−1] + K·x[n]. Real integrators (op-amp
circuits) have a limited output swing, so the model **clamps** the result to ±1.0. Without the clamp, a
constant input would make the model's output grow forever, which the real circuit can't do.

Integrators are the core of sigma-delta modulators and of loop filters in PLLs and control loops.

### Watch out for
- Compute the new value first, then clamp it (clamping the old value is a one-cycle-late bug).
- Use the parameter `K`: the testbench also instantiates K = 0.25.
