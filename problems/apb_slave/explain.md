### How it works

APB transfers take two phases: SETUP (`psel = 1`, `penable = 0`) and ACCESS (`psel = penable = 1`). The
transfer completes in the access phase when `pready = 1`. With no wait states, every transfer takes exactly two
cycles:

```
pclk    _/‾\_/‾\_/‾\_
psel    __/‾‾‾‾‾‾‾\__
penable ______/‾‾‾\__
          setup access
```

The register block decodes `paddr`, applies `pstrb` byte lanes on writes, and flags errors with `pslverr` in the
access phase.

### Watch out for
- Errored writes must not change anything, and they aren't counted in WCOUNT.
- `pslverr` is only meaningful in the access phase, so drive it low otherwise.
