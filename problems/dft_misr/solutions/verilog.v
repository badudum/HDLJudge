module misr8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [7:0] din,
    input  wire [7:0] golden,
    output reg  [7:0] sig,
    output wire       pass
);
    always @(posedge clk) begin
        if (rst)     sig <= 8'hFF;
        else if (en) sig <= ({sig[6:0], 1'b0} ^ (sig[7] ? 8'h1D : 8'h00)) ^ din;
    end
    assign pass = (sig == golden);
endmodule
