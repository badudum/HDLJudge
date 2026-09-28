module axil_gpio (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire [7:0]  awaddr,
    input  wire        awvalid,
    output reg         awready,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    input  wire        wvalid,
    output reg         wready,
    output reg  [1:0]  bresp,
    output reg         bvalid,
    input  wire        bready,
    input  wire [7:0]  araddr,
    input  wire        arvalid,
    output reg         arready,
    output reg  [31:0] rdata,
    output reg  [1:0]  rresp,
    output reg         rvalid,
    input  wire        rready,
    input  wire [7:0]  gpio_in,
    output reg  [7:0]  gpio_out,
    output reg  [7:0]  gpio_oe
);

    // Your code here

endmodule
