module apb_slave (
    input  wire        pclk,
    input  wire        presetn,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,
    input  wire [3:0]  pstrb,
    output reg  [31:0] prdata,
    output reg         pready,
    output reg         pslverr
);

    // Your code here

endmodule
