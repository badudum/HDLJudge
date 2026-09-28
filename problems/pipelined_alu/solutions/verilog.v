module pipe_alu (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        valid_in,
    input  wire [1:0]  op,
    input  wire [15:0] a,
    input  wire [15:0] b,
    output reg         valid_out,
    output reg  [15:0] y,
    output reg         zero
);
    reg        v1;
    reg [1:0]  op1;
    reg [15:0] a1, b1;
    reg [15:0] r;

    always @(*) begin
        case (op1)
            2'd0:    r = a1 + b1;
            2'd1:    r = a1 - b1;
            2'd2:    r = a1 & b1;
            default: r = a1 ^ b1;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            v1 <= 1'b0; valid_out <= 1'b0;
        end else if (!stall) begin
            valid_out <= v1;  y <= r;  zero <= (r == 16'd0);
            v1 <= valid_in;   op1 <= op;  a1 <= a;  b1 <= b;
        end
    end
endmodule
