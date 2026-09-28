module way_pred (
    input  wire        clk,
    input  wire        rst,
    input  wire        req,
    input  wire [5:0]  addr,
    output reg         pred,
    output reg         fast_hit,
    output reg         slow_hit,
    output reg         miss,
    output reg  [15:0] tag_reads
);
    reg       v [0:7];                 // index {set, way}
    reg [3:0] t [0:7];
    reg [3:0] mru;

    wire [1:0] s  = addr[1:0];
    wire [3:0] tg = addr[5:2];
    wire p     = mru[s];
    wire h0    = v[{s, 1'b0}] && t[{s, 1'b0}] == tg;
    wire h1    = v[{s, 1'b1}] && t[{s, 1'b1}] == tg;
    wire hp    = p ? h1 : h0;
    wire ho    = p ? h0 : h1;
    wire vic   = !v[{s, 1'b0}] ? 1'b0 : !v[{s, 1'b1}] ? 1'b1 : ~p;
    wire way   = hp ? p : ho ? ~p : vic;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) v[i] <= 1'b0;
            mru <= 4'd0; pred <= 1'b0; fast_hit <= 1'b0; slow_hit <= 1'b0; miss <= 1'b0; tag_reads <= 16'd0;
        end else if (req) begin
            pred <= p;
            fast_hit <= hp; slow_hit <= !hp && ho; miss <= !hp && !ho;
            tag_reads <= tag_reads + (hp ? 16'd1 : 16'd2);
            if (!hp && !ho) begin v[{s, vic}] <= 1'b1; t[{s, vic}] <= tg; end
            mru[s] <= way;
        end else begin
            fast_hit <= 1'b0; slow_hit <= 1'b0; miss <= 1'b0;
        end
    end
endmodule
