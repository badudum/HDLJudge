module ret_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       pwr_on,
    input  wire       save,
    input  wire       restore,
    input  wire       en,
    output wire [7:0] count_out
);
    reg [7:0] count, shadow;

    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0; shadow <= 8'd0;
        end else begin
            if (save) shadow <= count;
            if (!pwr_on)      count <= 8'd0;
            else if (en)      count <= count + 8'd1;
            else if (restore) count <= shadow;
        end
    end
    assign count_out = pwr_on ? count : 8'hFF;
endmodule
