module fu_tracker (
    input  wire       clk,
    input  wire       rst,
    input  wire       issue,
    input  wire [1:0] fu,
    input  wire [2:0] latency,
    output wire [3:0] busy,
    output reg        accepted
);
    reg [2:0] cnt [0:3];
    wire ok = issue && cnt[fu] == 3'd0 && latency != 3'd0;
    integer i;

    genvar g;
    generate
        for (g = 0; g < 4; g = g + 1) begin : b
            assign busy[g] = (cnt[g] != 3'd0);
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) cnt[i] <= 3'd0;
            accepted <= 1'b0;
        end else begin
            for (i = 0; i < 4; i = i + 1)
                if (ok && i == fu)       cnt[i] <= latency;
                else if (cnt[i] != 3'd0) cnt[i] <= cnt[i] - 3'd1;
            accepted <= ok;
        end
    end
endmodule
