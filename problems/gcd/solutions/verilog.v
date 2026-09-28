module gcd16 (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] a,
    input  wire [15:0] b,
    output reg         busy,
    output reg         done,
    output reg  [15:0] result
);
    reg [15:0] x, y;

    // Euclid by subtraction: one subtract or swap per cycle
    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy   <= 1'b0;
            result <= 16'd0;
        end else if (!busy) begin
            if (start) begin
                x    <= a;
                y    <= b;
                busy <= 1'b1;
            end
        end else if (y == 16'd0) begin
            result <= x;
            done   <= 1'b1;
            busy   <= 1'b0;
        end else if (x < y) begin
            x <= y;
            y <= x;
        end else begin
            x <= x - y;
        end
    end
endmodule
