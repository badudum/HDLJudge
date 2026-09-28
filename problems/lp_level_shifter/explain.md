### How it works

A low-voltage logic '1' (e.g. 0.8 V) may not fully turn off a PMOS in a 1.2 V domain, which causes leakage
or a wrong value. A level shifter converts the swing. The model adds two real-world features: a **Schmitt
trigger** (switching thresholds at 60 % / 40 % of VDDL, so a slow or noisy input doesn't chatter), and
built-in isolation when the low domain is off.

### Watch out for
- Inside the hysteresis band the output keeps its previous value.
- When `vddl` is below 0.3 V, the output is 0 and the stored state resets.
