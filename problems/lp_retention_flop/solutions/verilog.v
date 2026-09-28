module ret_reg (
    input  wire       clk,
    input  wire       rst,
    input  wire       pwr_on,
    input  wire       save,
    input  wire       restore,
    input  wire       en,
    input  wire [7:0] d,
    output wire [7:0] q_out
);
    reg [7:0] q, shadow;

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'd0; shadow <= 8'd0;
        end else begin
            if (save && pwr_on) shadow <= q;
            if (!pwr_on)      q <= 8'd0;            // state lost
            else if (restore) q <= shadow;
            else if (en)      q <= d;
        end
    end
    assign q_out = pwr_on ? q : 8'd0;
endmodule
