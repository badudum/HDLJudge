A **flash ADC** has one comparator per quantization level. Their outputs form a
*thermometer code*: all comparators below the input voltage output `1`, all above output `0`:

```
input level 5 of 15:   t = 000_0000_0001_1111
```

Metastability and comparator offsets sometimes produce **bubbles**, a `0` inside the run of
ones (`...0001_1011`). Build the 15-to-4 decoder that the ADC needs:

- `count` is the position of the **highest** `1` plus one (0 if no bit is set), which is the
  usual "top of the thermometer" decoding;
- `err` flags any code that is not a clean thermometer code.

### Interface

| Port    | Direction | Width |
|---------|-----------|-------|
| `t`     | input  | 15 |
| `count` | output | 4 |
| `err`   | output | 1 |
