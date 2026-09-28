module sp_ram16 (
    input  wire       clk,
    input  wire       en,
    input  wire       we,
    input  wire [3:0] addr,
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);
    reg [7:0] mem [0:15];

    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                mem[addr] <= wdata;          // fix 1: use all 4 address bits
                rdata     <= wdata;          // fix 2: write-first
            end else begin
                rdata <= mem[addr];
            end
        end
    end
endmodule
