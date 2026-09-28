module ras4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       push,
    input  wire       pop,
    input  wire [7:0] addr,
    output wire [7:0] top,
    output reg  [2:0] count
);
    reg [7:0] mem [0:3];
    reg [1:0] tp;                          // index of the top entry
    assign top = (count == 3'd0) ? 8'd0 : mem[tp];

    always @(posedge clk) begin
        if (rst) begin
            count <= 3'd0; tp <= 2'd3;
        end else if (push && pop && count != 3'd0) begin
            mem[tp] <= addr;                  // tail call
        end else if (push) begin
            mem[tp + 2'd1] <= addr;
            tp <= tp + 2'd1;
            if (count != 3'd4) count <= count + 3'd1;
        end else if (pop && count != 3'd0) begin
            tp <= tp - 2'd1;
            count <= count - 3'd1;
        end
    end
endmodule
