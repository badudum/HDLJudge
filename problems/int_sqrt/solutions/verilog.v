module isqrt16 (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] x,
    output reg         busy,
    output reg         done,
    output reg  [7:0]  root
);
    reg [15:0] xr;
    reg [2:0]  i;
    wire [7:0] cand = root | (8'd1 << i);

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0; root <= 8'd0;
        end else if (busy) begin
            if (cand * cand <= xr) root <= cand;
            i <= i - 3'd1;
            if (i == 3'd0) begin busy <= 1'b0; done <= 1'b1; end
        end else if (start) begin
            busy <= 1'b1; xr <= x; root <= 8'd0; i <= 3'd7;
        end
    end
endmodule
