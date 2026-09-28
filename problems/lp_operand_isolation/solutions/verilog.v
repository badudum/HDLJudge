module iso_alu (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire        op,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [15:0] y,
    output wire [15:0] add_in,
    output wire [15:0] mul_in
);
    reg [7:0] add_a, add_b, mul_a, mul_b;
    reg       op_q;

    always @(posedge clk) begin
        if (rst) begin
            add_a <= 0; add_b <= 0; mul_a <= 0; mul_b <= 0; op_q <= 0;
        end else if (en) begin
            op_q <= op;
            if (op) begin mul_a <= a; mul_b <= b; end
            else    begin add_a <= a; add_b <= b; end
        end
    end

    assign add_in = {add_a, add_b};
    assign mul_in = {mul_a, mul_b};
    assign y = op_q ? mul_a * mul_b : {8'd0, add_a} + {8'd0, add_b};
endmodule
