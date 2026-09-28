module gated_pipe (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] in_data,
    output reg        out_valid,
    output reg  [7:0] out_data
);
    reg       v1, v2;
    reg [7:0] d1, d2;

    always @(posedge clk) begin
        if (rst) begin
            v1 <= 0; v2 <= 0; out_valid <= 0; d1 <= 0; d2 <= 0; out_data <= 0;
        end else begin
            v1 <= in_valid; v2 <= v1; out_valid <= v2;
            if (in_valid) d1 <= in_data ^ 8'h5A;           // enables = clock gates
            if (v1)       d2 <= d1 + 8'd1;
            if (v2)       out_data <= {d2[6:0], d2[7]};
        end
    end
endmodule
