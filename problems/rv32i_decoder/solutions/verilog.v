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
    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    wire [31:0] imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    wire [31:0] imm_u = {instr[31:12], 12'b0};
    wire [31:0] imm_j = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

    always @(*) begin
        {reg_write, mem_read, mem_write, branch, jump} = 5'b0;
        fmt = 3'd7;
        imm = 32'd0;
        case (instr[6:0])
            7'b0110011: begin fmt = 3'd0; reg_write = 1'b1; end
            7'b0010011: begin fmt = 3'd1; imm = imm_i; reg_write = 1'b1; end
            7'b0000011: begin fmt = 3'd1; imm = imm_i; reg_write = 1'b1; mem_read = 1'b1; end
            7'b1100111: begin fmt = 3'd1; imm = imm_i; reg_write = 1'b1; jump = 1'b1; end
            7'b0100011: begin fmt = 3'd2; imm = imm_s; mem_write = 1'b1; end
            7'b1100011: begin fmt = 3'd3; imm = imm_b; branch = 1'b1; end
            7'b0110111,
            7'b0010111: begin fmt = 3'd4; imm = imm_u; reg_write = 1'b1; end
            7'b1101111: begin fmt = 3'd5; imm = imm_j; reg_write = 1'b1; jump = 1'b1; end
            default: ;
        endcase
    end
endmodule
