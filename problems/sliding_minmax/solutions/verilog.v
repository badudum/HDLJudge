module win_minmax (
    input  wire       clk,
    input  wire       rst,
    input  wire       valid,
    input  wire [7:0] din,
    output reg  [7:0] wmin,
    output reg  [7:0] wmax
);
    reg [7:0] w [0:6];              // the 7 newest stored samples
    reg [7:0] mn, mx;
    integer i;

    always @(*) begin
        mn = din; mx = din;
        for (i = 0; i < 7; i = i + 1) begin
            if (w[i] < mn) mn = w[i];
            if (w[i] > mx) mx = w[i];
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 7; i = i + 1) w[i] <= 8'd0;
            wmin <= 8'd0; wmax <= 8'd0;
        end else if (valid) begin
            w[0] <= din;
            for (i = 1; i < 7; i = i + 1) w[i] <= w[i-1];
            wmin <= mn; wmax <= mx;
        end
    end
endmodule
