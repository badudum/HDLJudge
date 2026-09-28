Instruction-stream generators are the core of CPU verification. Generate 20-instruction programs obeying frequency and sequencing rules.

### Class to complete

```systemverilog
class instr_stream;
    typedef enum bit [2:0] {NOP, LOAD, STORE, ADD, SUB, MUL, BR, JMP} op_t;
    rand op_t op[20];
    // constraints …
endclass
```
