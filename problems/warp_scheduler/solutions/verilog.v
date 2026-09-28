module warp_sched (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] ready,
    output reg        issue_valid,
    output reg  [1:0] issue_warp
);
    reg [1:0] ptr;
    reg [1:0] block [0:3];
    reg [3:0] elig;
    reg       found;
    reg [1:0] win;
    integer   k, w;

    always @(*) begin
        for (w = 0; w < 4; w = w + 1)
            elig[w] = ready[w] && block[w] == 2'd0;
        found = 1'b0;
        win   = 2'd0;
        for (k = 0; k < 4; k = k + 1)
            if (!found && elig[(ptr + k) % 4]) begin
                found = 1'b1;
                win   = (ptr + k) % 4;
            end
    end

    always @(posedge clk) begin
        if (rst) begin
            ptr <= 2'd0;
            issue_valid <= 1'b0;
            for (w = 0; w < 4; w = w + 1) block[w] <= 2'd0;
        end else begin
            for (w = 0; w < 4; w = w + 1)
                if (found && w == win)   block[w] <= 2'd2;
                else if (block[w] != 0)  block[w] <= block[w] - 2'd1;
            issue_valid <= found;
            if (found) begin
                issue_warp <= win;
                ptr        <= win + 2'd1;
            end
        end
    end
endmodule
