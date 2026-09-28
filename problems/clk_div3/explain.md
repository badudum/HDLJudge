### How it works

With rising-edge flops only, every high time is a whole number of input periods, so a 50 % duty cycle for
an odd ratio is impossible. The trick uses the falling edge as well:

```
clk   _/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_
p     _/‾‾‾\_______/‾‾‾\______     posedge flop, 1 of every 3 cycles
n     ___/‾‾‾\_______/‾‾‾\____     p delayed by half a cycle (negedge flop)
out   _/‾‾‾‾‾\_____/‾‾‾‾‾\____     p | n → 1.5 cycles high
```

The OR can't glitch, because when p falls, n is still high.

### Watch out for
- The negedge flop needs the reset too.
- Clocks must never pass through logic that can glitch. OR-ing two flop outputs that overlap is safe.
