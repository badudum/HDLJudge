// Correct, but the linear scan is too deep for the timing budget.
module max8 (
    input  wire [63:0] x,
    output reg  [7:0]  max,
    output reg  [2:0]  idx
);
    integer i;
    always @(*) begin
        max = x[7:0];
        idx = 3'd0;
        for (i = 1; i < 8; i = i + 1) begin
            if (x[8*i +: 8] > max) begin
                max = x[8*i +: 8];
                idx = i;
            end
        end
    end
endmodule
