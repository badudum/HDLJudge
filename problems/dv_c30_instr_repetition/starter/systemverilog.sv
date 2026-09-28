class instr_stream;
    typedef enum bit [2:0] {NOP, LOAD, STORE, ADD, SUB, MUL, BR, JMP} op_t;
    rand op_t op[20];

    // Your constraints here

endclass
