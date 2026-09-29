module mesi_line (
    input  wire       clk,
    input  wire       rst,
    input  wire       pr_rd,
    input  wire       pr_wr,
    input  wire       bus_rd,
    input  wire       bus_rdx,
    input  wire       shared_in,
    output reg  [1:0] state,
    output reg        wb
);
    localparam I = 2'd0, S = 2'd1, E = 2'd2, M = 2'd3;

    always @(posedge clk) begin
        if (rst) begin
            state <= I;
            wb    <= 1'b0;
        end else begin
            wb <= 1'b0;
            if (pr_rd) begin
                if (state == I) state <= shared_in ? S : E;
            end else if (pr_wr) begin
                state <= M;
            end else if (bus_rd) begin
                if (state == M) begin wb <= 1'b1; state <= S; end
                else if (state == E) state <= S;
            end else if (bus_rdx) begin
                if (state == M) wb <= 1'b1;
                state <= I;
            end
        end
    end
endmodule
