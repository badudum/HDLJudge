module wb_cache (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire       we,
    input  wire [5:0] addr,
    input  wire [7:0] wdata,
    input  wire [7:0] mem_rdata,
    output reg        hit,
    output reg  [7:0] rdata,
    output reg        wb_valid,
    output reg  [5:0] wb_addr,
    output reg  [7:0] wb_data
);
    reg       v   [0:7];          // index = {set, way}
    reg       d   [0:7];
    reg [3:0] t   [0:7];
    reg [7:0] x   [0:7];
    reg [3:0] lru;

    wire [1:0] s  = addr[1:0];
    wire [3:0] tg = addr[5:2];
    wire h0 = v[{s, 1'b0}] && t[{s, 1'b0}] == tg;
    wire h1 = v[{s, 1'b1}] && t[{s, 1'b1}] == tg;
    wire vic = !v[{s, 1'b0}] ? 1'b0 : !v[{s, 1'b1}] ? 1'b1 : lru[s];
    wire way = (h0 || h1) ? h1 : vic;
    wire [2:0] e = {s, way};
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) begin v[i] <= 1'b0; d[i] <= 1'b0; end
            lru <= 4'd0; hit <= 1'b0; wb_valid <= 1'b0;
        end else if (req) begin
            hit      <= h0 || h1;
            lru[s]   <= ~way;
            wb_valid <= 1'b0;
            if (h0 || h1) begin
                rdata <= x[e];
                if (we) begin x[e] <= wdata; d[e] <= 1'b1; end
            end else begin
                if (v[e] && d[e]) begin
                    wb_valid <= 1'b1; wb_addr <= {t[e], s}; wb_data <= x[e];
                end
                v[e] <= 1'b1; t[e] <= tg; d[e] <= we;
                x[e] <= we ? wdata : mem_rdata;
                rdata <= mem_rdata;
            end
        end else begin
            hit <= 1'b0; wb_valid <= 1'b0;
        end
    end
endmodule
