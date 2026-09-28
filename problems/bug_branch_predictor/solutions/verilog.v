module bht (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] pc,
    input  wire       update,
    input  wire [7:0] upd_pc,
    input  wire       taken,
    output wire       pred,
    output wire [1:0] ctr
);
    reg [1:0] t [0:15];
    wire [3:0] ui = upd_pc[5:2];
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) t[i] <= 2'b01;      // weakly not-taken
        end else if (update) begin
            if (taken && t[ui] != 2'b11)      t[ui] <= t[ui] + 2'd1;
            else if (!taken && t[ui] != 2'b00) t[ui] <= t[ui] - 2'd1;
        end
    end
    assign ctr  = t[pc[5:2]];
    assign pred = ctr[1];
endmodule
