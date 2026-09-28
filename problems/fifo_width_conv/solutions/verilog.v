module width_conv (
    input  wire        clk,
    input  wire        rst,
    input  wire        in_valid,
    input  wire [7:0]  in_data,
    output wire        in_ready,
    output reg         out_valid,
    output reg  [31:0] out_data,
    input  wire        out_ready
);
    reg [1:0]  cnt;
    reg [23:0] acc;

    assign in_ready = !out_valid || out_ready;
    wire take = in_valid && in_ready;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 2'd0; acc <= 24'd0; out_valid <= 1'b0;
        end else begin
            if (out_valid && out_ready) out_valid <= 1'b0;
            if (take) begin
                if (cnt == 2'd3) begin
                    out_data  <= {in_data, acc};
                    out_valid <= 1'b1;
                    acc       <= 24'd0;
                end else begin
                    acc[8*cnt +: 8] <= in_data;
                end
                cnt <= cnt + 2'd1;
            end
        end
    end
endmodule
