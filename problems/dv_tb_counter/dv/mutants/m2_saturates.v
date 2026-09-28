module counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] count
);
    always @(posedge clk) begin
        if (rst)                        count <= 4'd0;
        else if (en && count != 4'd15) count <= count + 4'd1;
    end
endmodule
