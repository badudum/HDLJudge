module shift_reg (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [7:0] din,
    input  wire       shift,
    input  wire       dir,
    input  wire       serial_in,
    output reg  [7:0] q,
    output wire       serial_out
);
    always @(posedge clk) begin
        if (rst)        q <= 8'd0;
        else if (load)  q <= din;
        else if (shift) q <= dir ? {serial_in, q[7:1]} : {q[6:0], serial_in};
    end
    assign serial_out = dir ? q[0] : q[7];
endmodule
