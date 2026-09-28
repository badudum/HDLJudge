module pipe3 (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,
    input  wire        in_valid,
    input  wire [15:0] in_data,
    output reg         out_valid,
    output reg  [15:0] out_data
);
    reg        v1, v2;
    reg [15:0] d1, d2;

    always @(posedge clk) begin
        if (rst) begin
            v1 <= 1'b0; v2 <= 1'b0; out_valid <= 1'b0;
        end else if (flush) begin
            out_valid <= v2; out_data <= d2;      // oldest instruction completes
            v2 <= 1'b0; v1 <= 1'b0;               // younger ones become bubbles
        end else if (!stall) begin
            out_valid <= v2; out_data <= d2;
            v2 <= v1;        d2 <= d1;
            v1 <= in_valid;  d1 <= in_data;
        end
    end
endmodule
