class instr_stream;
    typedef enum bit [2:0] {NOP, LOAD, STORE, ADD, SUB, MUL, BR, JMP} op_t;
    rand op_t op[20];

    constraint c_count {
        op.sum() with (int'(item == NOP))   <= 5;  op.sum() with (int'(item == LOAD)) <= 5;
        op.sum() with (int'(item == STORE)) <= 5;  op.sum() with (int'(item == ADD))  <= 5;
        op.sum() with (int'(item == SUB))   <= 5;  op.sum() with (int'(item == MUL))  <= 5;
        op.sum() with (int'(item == BR))    <= 5;  op.sum() with (int'(item == JMP))  <= 5;
    }
    constraint c_seq { foreach (op[i]) if (i < 19) { (op[i] == LOAD) -> (op[i+1] != STORE);
                                                      !(op[i] == NOP && op[i+1] == NOP); } }
    constraint c_end { op[19] inside {BR, JMP}; }
endclass
