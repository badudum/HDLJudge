module gray_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [4:0] gray,
    output reg  [4:0] bin
);
    wire [4:0] bin_next = bin + 5'd1;

    always @(posedge clk) begin
        if (rst) begin
            bin  <= 5'd0;
            gray <= 5'd0;
        end else if (en) begin
            bin  <= bin_next;
            gray <= bin_next ^ (bin_next >> 1);    // registered, glitch-free Gray output
        end
    end
endmodule
