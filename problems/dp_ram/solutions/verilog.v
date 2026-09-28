module dp_ram32 (
    input  wire       clk,
    input  wire       we_a,
    input  wire [4:0] addr_a,
    input  wire [7:0] din_a,
    output reg  [7:0] dout_a,
    input  wire       we_b,
    input  wire [4:0] addr_b,
    input  wire [7:0] din_b,
    output reg  [7:0] dout_b
);
    reg [7:0] mem [0:31];
    always @(posedge clk) begin
        dout_a <= mem[addr_a];
        dout_b <= mem[addr_b];
        if (we_b) mem[addr_b] <= din_b;
        if (we_a) mem[addr_a] <= din_a;        // later assignment wins on a collision
    end
endmodule
