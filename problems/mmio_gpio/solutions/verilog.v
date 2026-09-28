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
    reg [7:0] s1, s2, s3, rise;

    always @(posedge clk) begin
        if (rst) begin
            gpio_out <= 0; gpio_oe <= 0; s1 <= 0; s2 <= 0; s3 <= 0; rise <= 0;
        end else begin
            s1 <= gpio_in; s2 <= s1; s3 <= s2;
            rise <= (rise & ~((we && addr == 2'd3) ? wdata : 8'h00)) | (s2 & ~s3);
            if (we && addr == 2'd0) gpio_out <= wdata;
            if (we && addr == 2'd1) gpio_oe  <= wdata;
        end
    end

    always @(*) begin
        case (addr)
            2'd0:    rdata = gpio_out;
            2'd1:    rdata = gpio_oe;
            2'd2:    rdata = s2;
            default: rdata = rise;
        endcase
    end
endmodule
