module rv32i_decode (
    input  wire [31:0] instr,
    output reg  [2:0]  fmt,
    output reg  [31:0] imm,
    output reg         reg_write,
    output reg         mem_read,
    output reg         mem_write,
    output reg         branch,
    output reg         jump
);

    // Your code here

endmodule
