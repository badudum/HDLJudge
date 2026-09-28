module sync_edge (
    input  wire clk_fast,
    input  wire rst,
    input  wire d_slow,
    output wire q,
    output wire rise
);
    reg s1, s2, s3;
    always @(posedge clk_fast)
        if (rst) begin s1 <= 1'b0; s2 <= 1'b0; s3 <= 1'b0; end
        else     begin s1 <= d_slow; s2 <= s1; s3 <= s2; end
    assign q    = s2;
    assign rise = s2 & ~s3;
endmodule
