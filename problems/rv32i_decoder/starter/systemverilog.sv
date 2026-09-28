module rv32i_decode (
    input  logic [31:0] instr,
    output logic [2:0]  fmt,
    output logic [31:0] imm,
    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        branch,
    output logic        jump
);

    // Your code here

endmodule
