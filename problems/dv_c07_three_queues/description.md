A classic interview question: **randomly split a set into groups** with rules. Here, 12 items go
into 3 queues. Every queue gets something and no two queues are the same size.

The trick is to randomize something easy to constrain (which queue each item goes to) and build the
queues in `post_randomize()`.

### Class to complete

```systemverilog
class three_q;
    rand bit [1:0] owner[12];     // queue (0..2) that item i+1 goes to
    int q[3][$];                 // built in post_randomize()
    // constraints …
endclass
```
