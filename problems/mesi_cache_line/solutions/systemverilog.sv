module mesi_line (
    input  logic       clk,
    input  logic       rst,
    input  logic       pr_rd,
    input  logic       pr_wr,
    input  logic       bus_rd,
    input  logic       bus_rdx,
    input  logic       shared_in,
    output logic [1:0] state,
    output logic       wb
);
    localparam logic [1:0] I = 2'd0, S = 2'd1, E = 2'd2, M = 2'd3;

    always_ff @(posedge clk) begin
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
