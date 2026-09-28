### How it works

The driver turns one transaction (a 32-bit word) into a sequence of bus beats. For each beat: drive it,
wait for the handshake, move on:

```
for (i = 0; i < 4; i++) begin
    vif.valid <= 1; vif.data <= w[8*i +: 8]; vif.last <= (i == 3);
    do @(posedge vif.clk); while (!vif.ready);
end
```

Leaving `valid` high between words, when the next `drive()` call follows immediately, gives full throughput.

### Watch out for
- Hold valid, data and last stable while `ready = 0`.
- Drive with nonblocking assignments right after the clock edge.
