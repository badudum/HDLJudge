module vending (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] coin,
    output reg        dispense,
    output reg  [5:0] change,
    output reg  [5:0] credit
);
    reg [5:0] value;
    wire [5:0] total = credit + value;

    always @(*) begin
        case (coin)
            2'd1:    value = 6'd5;
            2'd2:    value = 6'd10;
            2'd3:    value = 6'd25;
            default: value = 6'd0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            credit <= 6'd0; dispense <= 1'b0; change <= 6'd0;
        end else if (total >= 6'd30) begin
            credit <= 6'd0; dispense <= 1'b1; change <= total - 6'd30;
        end else begin
            credit <= total; dispense <= 1'b0; change <= 6'd0;
        end
    end
endmodule
