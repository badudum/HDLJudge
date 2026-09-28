module pulse_detect (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output reg  pulse
);
    reg [1:0] hist;     // {older, newer}
    always @(posedge clk) begin
        if (rst) begin
            hist  <= 2'b00;
            pulse <= 1'b0;
        end else begin
            pulse <= (hist == 2'b01) && !din;
            hist  <= {hist[0], din};
        end
    end
endmodule
