module wrr_arb (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] req,
    output reg  [2:0] gnt
);
    reg [1:0] cur, cnt;
    wire [1:0] w = (cur == 2'd0) ? 2'd3 : (cur == 2'd1) ? 2'd2 : 2'd1;
    wire [1:0] n1 = (cur == 2'd2) ? 2'd0 : cur + 2'd1;
    wire [1:0] n2 = (n1 == 2'd2) ? 2'd0 : n1 + 2'd1;
    reg  [1:0] pick;
    reg        any;
    always @(*) begin
        any = 1'b1;
        if (req[n1])       pick = n1;
        else if (req[n2])  pick = n2;
        else if (req[cur]) pick = cur;
        else begin pick = cur; any = 1'b0; end
    end

    always @(posedge clk) begin
        if (rst) begin
            cur <= 2'd2; cnt <= 2'd1; gnt <= 3'b000;
        end else if (req[cur] && cnt < w) begin
            cnt <= cnt + 2'd1; gnt <= 3'b001 << cur;
        end else if (any) begin
            cur <= pick; cnt <= 2'd1; gnt <= 3'b001 << pick;
        end else begin
            gnt <= 3'b000;
        end
    end
endmodule
