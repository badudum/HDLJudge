module regfile (
    input  wire        clk,
    input  wire        we,
    input  wire [4:0]  waddr,
    input  wire [31:0] wdata,
    input  wire [4:0]  raddr1,
    input  wire [4:0]  raddr2,
    output reg  [31:0] rdata1,
    output reg  [31:0] rdata2
);

    // Your code here

endmodule
