module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_5,
    output reg  [3:0] alu_ctrl
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'd0;
            2'b01: alu_ctrl = 4'd1;
            default: begin
                case (funct3)
                    3'b000: alu_ctrl = (alu_op == 2'b10 && funct7_5) ? 4'd1 : 4'd0;
                    3'b001: alu_ctrl = 4'd6;
                    3'b010: alu_ctrl = 4'd9;
                    3'b011: alu_ctrl = 4'd10;
                    3'b100: alu_ctrl = 4'd4;
                    3'b101: alu_ctrl = funct7_5 ? 4'd8 : 4'd7;
                    3'b110: alu_ctrl = 4'd3;
                    default: alu_ctrl = 4'd2;
                endcase
            end
        endcase
    end
endmodule
