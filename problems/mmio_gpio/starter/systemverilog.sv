module mmio_gpio (
    input  logic       clk,
    input  logic       rst,
    input  logic       we,
    input  logic [1:0] addr,
    input  logic [7:0] wdata,
    output logic [7:0] rdata,
    input  logic [7:0] gpio_in,
    output logic [7:0] gpio_out,
    output logic [7:0] gpio_oe
);

    // Your code here

endmodule
