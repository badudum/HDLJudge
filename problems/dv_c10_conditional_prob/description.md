Constraints decide what is *legal*. Distributions decide what is *likely*. Stimulus quality depends
on both. Generate `(mode, len)` pairs with a conditional distribution:

| | probability |
|---|---|
| `mode = 1` | 70 % |
| `len = 15` given `mode = 1` | 50 % |
| other `len` values given `mode = 1` (8 … 14) | 50 % together |
| `len` given `mode = 0` | anything in 0 … 7 |

### Class to complete

```systemverilog
class cond_prob;
    rand bit       mode;
    rand bit [3:0] len;
    // constraints …
endclass
```
