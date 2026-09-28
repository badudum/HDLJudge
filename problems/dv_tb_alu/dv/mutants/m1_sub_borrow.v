module alu8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,
    output reg  [7:0] y,
    output reg        carry,
    output wire       zero,
    output wire       neg
);
    wire [2:0] sh = b[2:0];
    always @(*) begin
        carry = 1'b0;
        case (op)
            3'd0: {carry, y} = {1'b0, a} + {1'b0, b};                     // ADD, carry out
            3'd1: begin y = a - b; carry = (a >= b); end                   // SUB, borrow
            3'd2: y = a & b;
            3'd3: y = a | b;
            3'd4: y = a ^ b;
            3'd5: begin y = a << sh; carry = (sh != 0) ? a[8 - sh] : 1'b0; end   // SHL, last bit out
            3'd6: begin y = a >> sh; carry = (sh != 0) ? a[sh - 1] : 1'b0; end   // SHR (logical)
            default: y = {7'd0, $signed(a) < $signed(b)};                 // SLT (signed)
        endcase
    end
    assign zero = (y == 8'd0);
    assign neg  = y[7];
endmodule
