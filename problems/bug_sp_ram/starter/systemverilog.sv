module sp_ram16 (
    input  wire       clk,
    input  wire       en,
    input  wire       we,
    input  wire [3:0] addr,
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);
    reg [7:0] mem [0:15];
    wire [2:0] a = addr[2:0];

    always @(posedge clk) begin
        if (en) begin
            if (we) mem[a] <= wdata;
            rdata <= mem[a];
        end
    end
endmodule
