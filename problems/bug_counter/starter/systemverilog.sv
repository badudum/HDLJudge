module bcd_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] digit,
    output wire       carry
);
    always @(posedge clk) begin
        if (rst)
            digit <= 4'd0;
        else if (en) begin
            if (digit == 4'd10)
                digit <= 4'd0;
            else
                digit <= digit + 4'd1;
        end
    end

    assign carry = (digit == 4'd9);
endmodule
