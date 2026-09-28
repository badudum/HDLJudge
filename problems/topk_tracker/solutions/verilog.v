module top3 (
    input  wire       clk,
    input  wire       rst,
    input  wire       valid,
    input  wire [7:0] din,
    output reg  [7:0] t0,
    output reg  [7:0] t1,
    output reg  [7:0] t2
);
    wire g0 = din > t0;
    wire g1 = din > t1;
    wire g2 = din > t2;

    always @(posedge clk) begin
        if (rst) begin
            t0 <= 8'd0; t1 <= 8'd0; t2 <= 8'd0;
        end else if (valid) begin
            if (g0) begin
                t0 <= din; t1 <= t0; t2 <= t1;
            end else if (g1) begin
                t1 <= din; t2 <= t1;
            end else if (g2) begin
                t2 <= din;
            end
        end
    end
endmodule
