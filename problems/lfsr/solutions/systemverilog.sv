module lfsr8 (
    input  logic       clk,
    input  logic       rst,
    input  logic       load,
    input  logic [7:0] seed,
    input  logic       en,
    output logic [7:0] q
);
    always_ff @(posedge clk) begin
        if (rst)       q <= 8'h01;
        else if (load) q <= seed;
        else if (en)   q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]};
    end
endmodule
