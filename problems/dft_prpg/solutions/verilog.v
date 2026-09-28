module prpg (
    input  wire        clk,
    input  wire        rst,
    input  wire        load,
    input  wire [15:0] seed,
    input  wire        en,
    output reg  [15:0] state,
    output wire [3:0]  chains
);
    wire fb = state[15] ^ state[13] ^ state[12] ^ state[10];
    always @(posedge clk) begin
        if (rst)       state <= 16'hACE1;
        else if (load) state <= seed;
        else if (en)   state <= {state[14:0], fb};
    end
    assign chains = {state[2] ^ state[14], state[7] ^ state[12], state[3] ^ state[9], state[0] ^ state[5]};
endmodule
