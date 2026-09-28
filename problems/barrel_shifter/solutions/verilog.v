module barrel_shifter #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0]         din,
    input  wire [$clog2(WIDTH)-1:0] shamt,
    input  wire [1:0]               op,
    output reg  [WIDTH-1:0]         dout
);
    localparam S = $clog2(WIDTH);
    reg [WIDTH-1:0] v;
    reg [WIDTH-1:0] fill;
    integer k, i;

    // logarithmic shifter: stage k moves the data by 2^k positions
    always @(*) begin
        v = din;
        for (k = 0; k < S; k = k + 1) begin
            if (shamt[k]) begin
                if (op == 2'b00) begin
                    v = v << (1 << k);
                end else begin
                    case (op)
                        2'b01:   fill = {WIDTH{1'b0}};
                        2'b10:   fill = {WIDTH{din[WIDTH-1]}};
                        default: fill = v;                       // rotate: wrap around
                    endcase
                    for (i = 0; i < WIDTH; i = i + 1)
                        v[i] = (i + (1 << k) < WIDTH) ? v[i + (1 << k)] : fill[i + (1 << k) - WIDTH];
                end
            end
        end
        dout = v;
    end
endmodule
