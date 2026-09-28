module dirty_tracker (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] op,
    input  wire [2:0] index,
    output reg  [7:0] valid,
    output reg  [7:0] dirty,
    output reg        writeback,
    output reg  [2:0] wb_index
);
    wire evict = (op == 2'b10 || op == 2'b11) && valid[index] && dirty[index];

    always @(posedge clk) begin
        if (rst) begin
            valid <= 8'd0; dirty <= 8'd0; writeback <= 1'b0; wb_index <= 3'd0;
        end else begin
            writeback <= evict;
            if (evict) wb_index <= index;
            case (op)
                2'b01: begin valid[index] <= 1'b1; dirty[index] <= 1'b1; end
                2'b10: begin valid[index] <= 1'b1; dirty[index] <= 1'b0; end
                2'b11: begin valid[index] <= 1'b0; dirty[index] <= 1'b0; end
                default: ;
            endcase
        end
    end
endmodule
