module seq_div (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] dividend,
    input  wire [15:0] divisor,
    output reg         busy,
    output reg         done,
    output reg  [15:0] quotient,
    output reg  [15:0] remainder
);

    // Your code here

endmodule
