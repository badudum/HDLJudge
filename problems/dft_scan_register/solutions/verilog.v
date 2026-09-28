module scan_reg (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] d,
    input  wire       se,
    input  wire       si,
    output reg  [7:0] q,
    output wire       so
);
    always @(posedge clk) begin
        if (rst)     q <= 8'd0;
        else if (se) q <= {q[6:0], si};     // scan shift
        else         q <= d;                // functional capture
    end
    assign so = q[7];
endmodule
