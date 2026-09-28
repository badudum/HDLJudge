Write a **parameterized binary decoder**: N select bits drive 2ᴺ one-hot outputs. Address
decoders, register write-enables and interrupt vectors all use one.

```
N = 2:   sel  en | y
         --   0  | 0000
         00   1  | 0001
         01   1  | 0010
         10   1  | 0100
         11   1  | 1000
```

The judge instantiates your module with **N = 5**. Make sure the widths follow the parameter.

### Interface

| Name | Kind | Width |
|------|------|-------|
| `N`   | parameter / generic | default 3 |
| `sel` | input  | N |
| `en`  | input  | 1 |
| `y`   | output | 2ᴺ |
