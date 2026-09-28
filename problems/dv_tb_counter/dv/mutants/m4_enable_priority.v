module counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] count
);
    always @(posedge clk) begin
        if (en)       count <= count + 4'd1;
        else if (rst) count <= 4'd0;
    end
endmodule
