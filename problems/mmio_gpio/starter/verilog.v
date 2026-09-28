module mmio_gpio (
    input  wire       clk,
    input  wire       rst,
    input  wire       we,
    input  wire [1:0] addr,
    input  wire [7:0] wdata,
    output reg  [7:0] rdata,
    input  wire [7:0] gpio_in,
    output reg  [7:0] gpio_out,
    output reg  [7:0] gpio_oe
);

    // Your code here

endmodule
