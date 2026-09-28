module spi_master (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic [7:0] tx_data,
    input  logic       miso,
    output logic       sclk,
    output logic       mosi,
    output logic       cs_n,
    output logic       busy,
    output logic       done,
    output logic [7:0] rx_data
);

    // Your code here

endmodule
