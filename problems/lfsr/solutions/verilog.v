module lfsr8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [7:0] seed,
    input  wire       en,
    output reg  [7:0] q
);
    wire fb = q[7] ^ q[5] ^ q[4] ^ q[3];

    always @(posedge clk) begin
        if (rst)       q <= 8'h01;
        else if (load) q <= seed;
        else if (en)   q <= {q[6:0], fb};
    end
endmodule
