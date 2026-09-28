Every PLL contains a **voltage-controlled oscillator**. Its output frequency is proportional
to a control voltage. Mixed-signal verification relies on fast behavioral VCO models like the
one you'll write here.

```
f(vctrl) = F0 + KVCO · vctrl        clamped to 1 MHz … 1 GHz

  F0   = free-running frequency (Hz)       default 100 MHz
  KVCO = tuning gain (Hz per volt)         default 50 MHz/V
```

`clk_out` starts at 0 and toggles every half period, `1 / (2·f)`. Each half period uses the
value of `vctrl` when it begins, so frequency changes are phase-continuous (no glitches).

The testbench measures the frequency (average over 20 periods) and the duty cycle at several
control voltages, on two instances with different parameters.

### Interface

| Name      | Kind | Type |
|-----------|------|------|
| `F0`      | parameter / generic | `real`, Hz |
| `KVCO`    | parameter / generic | `real`, Hz/V |
| `vctrl`   | input  | `real`, volts |
| `clk_out` | output | 1 bit |
