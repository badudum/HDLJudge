module byte_rf (
    input  logic        clk,
    input  logic        rst,
    input  logic        we,
    input  logic [1:0]  waddr,
    input  logic [3:0]  wbe,
    input  logic [31:0] wdata,
    input  logic [1:0]  raddr,
    output logic [31:0] rdata,
    output logic [15:0] cg_en
);

    // Your code here

endmodule
