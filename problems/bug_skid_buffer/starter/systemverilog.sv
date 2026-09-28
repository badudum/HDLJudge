module skid_buffer (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] in_data,
    output wire       in_ready,
    output reg        out_valid,
    output reg  [7:0] out_data,
    input  wire       out_ready
);
    reg       skid_valid;
    reg [7:0] skid_data;
    assign in_ready = !skid_valid;

    always @(posedge clk) begin
        if (rst) begin
            out_valid <= 1'b0; skid_valid <= 1'b0;
        end else if (!out_valid || out_ready) begin
            if (in_valid) begin
                out_valid <= 1'b1;
                out_data  <= in_data;
            end else if (skid_valid) begin
                out_data <= skid_data; out_valid <= 1'b1; skid_valid <= 1'b0;
            end else begin
                out_valid <= 1'b0;
            end
        end else if (in_valid) begin
            skid_valid <= 1'b1; skid_data <= in_data;
        end
    end
endmodule
