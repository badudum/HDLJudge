module reg_slice (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] in_data,
    output wire       in_ready,
    output reg        out_valid,
    output reg  [7:0] out_data,
    input  wire       out_ready
);
    assign in_ready = !out_valid || out_ready;          // fix 1: only accept into a free slot

    always @(posedge clk) begin
        if (rst) begin
            out_valid <= 1'b0;
        end else if (in_valid && in_ready) begin       // fix 2: loading wins over emptying
            out_data  <= in_data;
            out_valid <= 1'b1;
        end else if (out_ready) begin
            out_valid <= 1'b0;
        end
    end
endmodule
