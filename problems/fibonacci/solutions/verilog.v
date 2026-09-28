module fib_gen (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    output reg  [15:0] fib,
    output reg         overflow
);
    reg  [15:0] prev;
    wire [16:0] next = prev + fib;

    always @(posedge clk) begin
        if (rst) begin
            prev <= 16'd1;
            fib  <= 16'd0;
            overflow <= 1'b0;
        end else if (en && !overflow) begin
            if (next[16]) begin
                overflow <= 1'b1;
            end else begin
                prev <= fib;
                fib  <= next[15:0];
            end
        end
    end
endmodule
