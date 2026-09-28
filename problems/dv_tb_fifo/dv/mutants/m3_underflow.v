module sync_fifo4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,
    input  wire       rd_en,
    input  wire [7:0] din,
    output wire [7:0] dout,
    output wire       full,
    output wire       empty,
    output reg  [2:0] count
);
    reg [7:0] mem [0:3];
    reg [1:0] wptr, rptr;
    wire do_wr = wr_en && !full;
    wire do_rd = rd_en;

    always @(posedge clk) begin
        if (rst) begin
            wptr <= 2'd0; rptr <= 2'd0; count <= 3'd0;
        end else begin
            if (do_wr) begin mem[wptr] <= din; wptr <= wptr + 2'd1; end
            if (do_rd) rptr <= rptr + 2'd1;
            count <= count + {2'd0, do_wr} - {2'd0, do_rd};
        end
    end
    assign dout  = mem[rptr];            // first-word fall-through
    assign full  = (count == 3'd4);
    assign empty = (count == 3'd0);
endmodule
