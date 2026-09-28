module toggle_mon (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] bus,
    input  wire [7:0] threshold,
    output reg  [7:0] activity,
    output reg        hot
);
    reg  [7:0] prev, acc;
    reg  [3:0] n;
    wire [7:0] d = bus ^ prev;
    wire [3:0] pc = d[0] + d[1] + d[2] + d[3] + d[4] + d[5] + d[6] + d[7];
    wire [7:0] nacc = acc + pc;
    always @(posedge clk) begin
        if (rst) begin
            prev <= 0; acc <= 0; n <= 0; activity <= 0; hot <= 0;
        end else begin
            prev <= bus;
            n    <= n + 4'd1;
            if (n == 4'd15) begin
                activity <= nacc; hot <= nacc > threshold; acc <= 8'd0;
            end else
                acc <= nacc;
        end
    end
endmodule
