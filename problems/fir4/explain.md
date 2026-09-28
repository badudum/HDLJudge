### How it works

A finite impulse response filter computes a weighted sum of the last N input samples:

```
y[n] = h0·x[n] + h1·x[n−1] + h2·x[n−2] + h3·x[n−3]      h = (1, 3, 3, 1)
```

Keep the three previous samples in a shift register. On each valid sample, compute the sum with the
**new** sample and register it. Multiplying by 3 is `(x << 1) + x`, so no multiplier is needed. The (1, 3, 3, 1)
kernel is a binomial low-pass filter: it smooths the signal, and its DC gain is 8 (the coefficients sum to 8).

### Watch out for
- Sign-extend each 8-bit sample to 12 bits before adding: the samples are signed.
- Without `valid`, neither the delay line nor the output changes.
