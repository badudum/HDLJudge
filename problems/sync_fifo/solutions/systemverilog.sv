module sync_fifo (
    input  logic       clk,
    input  logic       rst,
    input  logic       wr_en,
    input  logic [7:0] din,
    input  logic       rd_en,
    output logic [7:0] dout,
    output logic       full,
    output logic       empty,
    output logic [3:0] count
);
    logic [7:0] mem [8];
    logic [3:0] wp, rp;          // one extra bit distinguishes full from empty

    logic do_wr, do_rd;
    assign do_wr = wr_en && !full;
    assign do_rd = rd_en && !empty;

    assign count = wp - rp;
    assign empty = (wp == rp);
    assign full  = (wp[2:0] == rp[2:0]) && (wp[3] != rp[3]);

    always_ff @(posedge clk) begin
        if (do_wr) mem[wp[2:0]] <= din;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            wp <= '0; rp <= '0; dout <= '0;
        end else begin
            if (do_wr) wp <= wp + 1'b1;
            if (do_rd) begin
                dout <= mem[rp[2:0]];
                rp   <= rp + 1'b1;
            end
        end
    end
endmodule
