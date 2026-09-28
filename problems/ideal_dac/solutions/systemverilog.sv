module dac8 #(
    parameter real VREF = 1.0
) (
    input  logic       clk,
    input  logic [7:0] code,
    output real        vout = 0.0
);
    always @(posedge clk)
        vout <= real'(code) / 256.0 * VREF;
endmodule
