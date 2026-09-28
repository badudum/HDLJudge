module lfu4 (
    input  wire        clk,
    input  wire        rst,
    input  wire        hit,
    input  wire [1:0]  way,
    input  wire        fill,
    output reg  [1:0]  victim,
    output wire [11:0] counts
);
    reg [2:0] c [0:3];
    reg [2:0] inc;
    integer i;

    assign counts = {c[3], c[2], c[1], c[0]};

    always @(*) begin
        victim = 2'd0;
        for (i = 1; i < 4; i = i + 1)              // strict '<' keeps the lowest index on ties
            if (c[i] < c[victim]) victim = i;
        inc = (c[way] == 3'd7) ? 3'd7 : c[way] + 3'd1;
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) c[i] <= 3'd0;
        end else if (fill) begin
            c[victim] <= 3'd1;
        end else if (hit) begin
            if (inc == 3'd7) begin
                for (i = 0; i < 4; i = i + 1)
                    c[i] <= (i == way) ? (inc >> 1) : (c[i] >> 1);
            end else begin
                c[way] <= inc;
            end
        end
    end
endmodule
