module dm_cache (
    input  wire       clk,
    input  wire       rst,
    input  wire       rd,
    input  wire       wr,
    input  wire       fill,
    input  wire       inv,
    input  wire [7:0] addr,
    input  wire [7:0] wdata,
    input  wire [7:0] fill_data,
    output reg        hit,
    output reg  [7:0] rdata,
    output reg  [7:0] hits,
    output reg  [7:0] misses
);
    reg       valid [0:7];
    reg [4:0] tag   [0:7];
    reg [7:0] data  [0:7];

    wire [2:0] idx   = addr[2:0];
    wire       match = valid[idx] && tag[idx] == addr[7:3];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) valid[i] <= 1'b0;
            hit <= 1'b0; hits <= 8'd0; misses <= 8'd0;
        end else begin
            hit   <= (rd || wr) && match;
            rdata <= data[idx];
            if (rd) begin
                if (match) hits <= hits + 8'd1;
                else       misses <= misses + 8'd1;
            end
            if (wr && match) data[idx] <= wdata;
            if (fill) begin
                valid[idx] <= 1'b1; tag[idx] <= addr[7:3]; data[idx] <= fill_data;
            end
            if (inv)
                for (i = 0; i < 8; i = i + 1) valid[i] <= 1'b0;
        end
    end
endmodule
