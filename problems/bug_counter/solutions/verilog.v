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
            if (digit == 4'd9)                 // fix 1: 9 is the last decimal digit
                digit <= 4'd0;
            else
                digit <= digit + 4'd1;
        end
    end

    assign carry = en && (digit == 4'd9);      // fix 2: only carry while counting
endmodule
