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
    reg [5:0] c;
    reg [7:0] tx, rx;
    wire [5:0] cn = c + 6'd1;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 0; c <= 0; rx_data <= 0; sclk <= 0; mosi <= 0; cs_n <= 1;
        end else if (busy) begin
            c <= cn;
            if (cn[1:0] == 2'd2) begin
                sclk <= 1'b1;
                rx   <= {rx[6:0], miso};
            end else if (cn[1:0] == 2'd0) begin
                sclk <= 1'b0;
                if (cn < 6'd32) mosi <= tx[3'd7 - cn[4:2]];
                else begin
                    cs_n <= 1'b1; busy <= 1'b0; mosi <= 1'b0; done <= 1'b1; rx_data <= rx;
                end
            end
        end else if (start) begin
            busy <= 1'b1; c <= 6'd0; tx <= tx_data; cs_n <= 1'b0; mosi <= tx_data[7]; rx <= 8'd0;
        end
    end
endmodule
