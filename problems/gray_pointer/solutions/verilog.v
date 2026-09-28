module rd_ptr_gray (
    input  wire       clk,
    input  wire       rst,
    input  wire       rd_en,
    input  wire [3:0] wr_gray_sync,
    output reg  [3:0] rd_gray,
    output wire [2:0] rd_addr,
    output wire       empty
);
    reg  [3:0] rd_bin;
    wire [3:0] nxt = rd_bin + 4'd1;

    assign empty   = (rd_gray == wr_gray_sync);
    assign rd_addr = rd_bin[2:0];

    always @(posedge clk) begin
        if (rst) begin
            rd_bin  <= 4'd0;
            rd_gray <= 4'd0;
        end else if (rd_en && !empty) begin
            rd_bin  <= nxt;
            rd_gray <= nxt ^ (nxt >> 1);
        end
    end
endmodule
