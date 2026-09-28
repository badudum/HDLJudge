module alu #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0]       op,
    output reg  [WIDTH-1:0] y,
    output wire             zero,
    output reg              carry,
    output reg              overflow,
    output wire             negative
);
    localparam SW = $clog2(WIDTH);
    wire [SW-1:0] sh = b[SW-1:0];
    wire          is_sub = (op == 4'd1);
    wire [WIDTH-1:0] bb = is_sub ? ~b : b;
    wire [WIDTH:0]   sum = {1'b0, a} + {1'b0, bb} + is_sub;
    wire             ovf = (a[WIDTH-1] == bb[WIDTH-1]) && (sum[WIDTH-1] != a[WIDTH-1]);

    always @(*) begin
        carry    = 1'b0;
        overflow = 1'b0;
        case (op)
            4'd0, 4'd1: begin y = sum[WIDTH-1:0]; carry = sum[WIDTH]; overflow = ovf; end
            4'd2:  y = a & b;
            4'd3:  y = a | b;
            4'd4:  y = a ^ b;
            4'd5:  y = ~(a | b);
            4'd6:  y = a << sh;
            4'd7:  y = a >> sh;
            4'd8:  y = $signed(a) >>> sh;
            4'd9:  y = ($signed(a) < $signed(b)) ? 1 : 0;
            4'd10: y = (a < b) ? 1 : 0;
            default: y = 0;
        endcase
    end

    assign zero     = (y == 0);
    assign negative = y[WIDTH-1];
endmodule
