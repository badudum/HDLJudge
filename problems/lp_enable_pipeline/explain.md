### How it works

In a pipeline, bubbles (cycles without valid data) still clock every data register, so garbage toggles
through the datapath and wastes power. Enabling each stage's data register only when valid data arrives
("data gating") removes that switching. Because the enable is an ordinary clock-enable, synthesis can map it onto an
integrated clock gate.

### Watch out for
- The valid bits themselves are always clocked, since they are cheap.
- During bubbles `out_data` holds the last valid result.
