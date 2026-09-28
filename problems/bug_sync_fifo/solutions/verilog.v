module sync_fifo (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,
    input  wire [7:0] din,
    input  wire       rd_en,
    output reg  [7:0] dout,
    output wire       full,
    output wire       empty,
    output wire [3:0] count
);
    reg [7:0] mem [0:7];
    reg [2:0] wp, rp;
    reg [3:0] cnt;

    wire do_wr = wr_en && !full;
    wire do_rd = rd_en && !empty;

    assign count = cnt;
    assign full  = (cnt == 4'd8);
    assign empty = (cnt == 4'd0);

    always @(posedge clk) begin
        if (do_wr) mem[wp] <= din;
    end

    always @(posedge clk) begin
        if (rst) begin
            wp <= 3'd0; rp <= 3'd0; cnt <= 4'd0; dout <= 8'd0;
        end else begin
            if (do_wr) wp <= wp + 3'd1;
            if (do_rd) begin
                dout <= mem[rp];
                rp   <= rp + 3'd1;
            end
            cnt <= cnt + {3'd0, do_wr} - {3'd0, do_rd};
        end
    end
endmodule
