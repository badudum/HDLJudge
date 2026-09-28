Generalize the queue-splitting problem: 10 items into **4** queues, each holding 2 or 3 items, each
kept sorted. Load balancers and packet schedulers get tested with exactly this kind of
stimulus.

### Class to complete

```systemverilog
class n_queues;
    rand bit [1:0] owner[10];     // queue (0..3) of item i
    int q[4][$];
    // constraints …
endclass
```
