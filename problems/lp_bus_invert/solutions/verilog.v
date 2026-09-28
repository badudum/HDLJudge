module bus_invert (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid,
    input  wire [7:0]  din,
    output reg  [7:0]  bus_q,
    output reg         inv,
    output wire [7:0]  dout,
    output reg  [15:0] toggles
);
    function [3:0] popcount(input [7:0] x);
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < 8; i = i + 1) popcount = popcount + x[i];
        end
    endfunction

    wire       flip   = popcount(din ^ bus_q) > 4;
    wire [7:0] nbus   = flip ? ~din : din;
    wire [4:0] ntog   = popcount(nbus ^ bus_q) + (flip ^ inv);

    always @(posedge clk) begin
        if (rst) begin
            bus_q <= 8'd0; inv <= 1'b0; toggles <= 16'd0;
        end else if (valid) begin
            bus_q <= nbus; inv <= flip;
            toggles <= toggles + ntog;
        end
    end
    assign dout = inv ? ~bus_q : bus_q;
endmodule
