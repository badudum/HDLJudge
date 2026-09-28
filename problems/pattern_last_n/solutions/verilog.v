module last_n_ones (
    input  wire       clk,
    input  wire       rst,
    input  wire       din,
    output reg  [3:0] count,
    output reg        alarm
);
    reg  [11:0] window;
    wire [3:0]  count_next = count + din - window[11];

    always @(posedge clk) begin
        if (rst) begin
            window <= 12'd0;
            count  <= 4'd0;
            alarm  <= 1'b0;
        end else begin
            window <= {window[10:0], din};
            count  <= count_next;
            alarm  <= (count_next >= 4'd8);
        end
    end
endmodule
