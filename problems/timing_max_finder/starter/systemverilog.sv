// Correct, but the linear scan is too deep for the timing budget.
module max8 (
    input  logic [63:0] x,
    output logic [7:0]  max,
    output logic [2:0]  idx
);
    always_comb begin
        max = x[7:0];
        idx = '0;
        for (int i = 1; i < 8; i++) begin
            if (x[8*i +: 8] > max) begin
                max = x[8*i +: 8];
                idx = 3'(i);
            end
        end
    end
endmodule
