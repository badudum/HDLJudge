module sync_edge (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire level,
    output wire rise,
    output wire fall
);
    reg s1, s2, s3;

    always @(posedge clk) begin
        if (rst) begin
            s1 <= 1'b0; s2 <= 1'b0; s3 <= 1'b0;
        end else begin
            s1 <= din;
            s2 <= s1;
            s3 <= s2;
        end
    end

    assign level = s2;
    assign rise  = s2 & ~s3;       // fix 1: never use the (possibly metastable) first stage
    assign fall  = ~s2 & s3;       // fix 2: falling edge = was 1, now 0
endmodule
