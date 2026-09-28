module sp_ram64 (
    input  wire       clk,
    input  wire       en,
    input  wire       we,
    input  wire [5:0] addr,
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);
    reg [7:0] mem [0:63];
    always @(posedge clk) begin
        if (en) begin
            if (we) mem[addr] <= wdata;
            rdata <= mem[addr];           // old contents: read-first
        end
    end
endmodule
