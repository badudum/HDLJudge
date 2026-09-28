module div_by_3 (
    input  logic clk,
    input  logic rst,
    input  logic din,
    output logic div
);
    typedef enum logic [1:0] {R0, R1, R2} rem_t;
    rem_t rem;
    always_ff @(posedge clk) begin
        if (rst) rem <= R0;
        else unique case (rem)
            R0: rem <= din ? R1 : R0;
            R1: rem <= din ? R0 : R2;
            R2: rem <= din ? R2 : R1;
            default: rem <= R0;
        endcase
    end
    assign div = (rem == R0);
endmodule
