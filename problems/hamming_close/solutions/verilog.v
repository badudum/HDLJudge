module close16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    output wire        close
);
    wire [15:0] d = a ^ b;
    assign close = ((d & (d - 16'd1)) == 16'd0);
endmodule
