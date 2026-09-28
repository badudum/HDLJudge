module byte_rf (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,
    input  wire [1:0]  waddr,
    input  wire [3:0]  wbe,
    input  wire [31:0] wdata,
    input  wire [1:0]  raddr,
    output reg  [31:0] rdata,
    output reg  [15:0] cg_en
);

    // Your code here

endmodule
