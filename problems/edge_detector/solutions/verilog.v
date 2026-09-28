module edge_detect (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output reg  pulse
);
    reg prev;
    always @(posedge clk) begin
        if (rst) begin
            prev  <= 1'b0;
            pulse <= 1'b0;
        end else begin
            prev  <= din;
            pulse <= din & ~prev;
        end
    end
endmodule
