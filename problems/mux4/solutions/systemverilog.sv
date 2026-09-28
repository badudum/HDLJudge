module mux4 (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [7:0] c,
    input  logic [7:0] d,
    input  logic [1:0] sel,
    output logic [7:0] y
);
    always_comb begin
        unique case (sel)
            2'd0: y = a;
            2'd1: y = b;
            2'd2: y = c;
            2'd3: y = d;
        endcase
    end
endmodule
