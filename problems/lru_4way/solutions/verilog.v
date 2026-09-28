module lru4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       touch,
    input  wire [1:0] way,
    output reg  [1:0] victim
);
    // age[i]: 0 = most recently used ... 3 = least recently used
    reg [1:0] age [0:3];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) age[i] <= 2'd3 - i;
        end else if (touch) begin
            for (i = 0; i < 4; i = i + 1)
                if (i == way)                age[i] <= 2'd0;
                else if (age[i] < age[way])  age[i] <= age[i] + 2'd1;
        end
    end

    always @(*) begin
        victim = 2'd0;
        for (i = 0; i < 4; i = i + 1)
            if (age[i] == 2'd3) victim = i;
    end
endmodule
