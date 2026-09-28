module decoder_n #(
    parameter N = 3
) (
    input  wire [N-1:0]      sel,
    input  wire              en,
    output wire [(1<<N)-1:0] y
);
    assign y = en ? ({{((1<<N)-1){1'b0}}, 1'b1} << sel) : {(1<<N){1'b0}};
endmodule
