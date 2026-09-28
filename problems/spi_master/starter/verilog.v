module spi_master (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       miso,
    output reg        sclk,
    output reg        mosi,
    output reg        cs_n,
    output reg        busy,
    output reg        done,
    output reg  [7:0] rx_data
);

    // Your code here

endmodule
