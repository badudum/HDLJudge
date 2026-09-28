module simd_alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        mode,
    input  wire [1:0]  op,
    output reg  [31:0] y
);
    function [7:0] lane8(input [7:0] x, input [7:0] z, input [1:0] o);
        reg [8:0] s;
        begin
            s = x + z;
            case (o)
                2'd0: lane8 = s[7:0];
                2'd1: lane8 = x - z;
                2'd2: lane8 = s[8] ? 8'hFF : s[7:0];
                default: lane8 = (x > z) ? x : z;
            endcase
        end
    endfunction

    function [15:0] lane16(input [15:0] x, input [15:0] z, input [1:0] o);
        reg [16:0] s;
        begin
            s = x + z;
            case (o)
                2'd0: lane16 = s[15:0];
                2'd1: lane16 = x - z;
                2'd2: lane16 = s[16] ? 16'hFFFF : s[15:0];
                default: lane16 = (x > z) ? x : z;
            endcase
        end
    endfunction

    always @(*) begin
        if (mode)
            y = {lane16(a[31:16], b[31:16], op), lane16(a[15:0], b[15:0], op)};
        else
            y = {lane8(a[31:24], b[31:24], op), lane8(a[23:16], b[23:16], op),
                 lane8(a[15:8],  b[15:8],  op), lane8(a[7:0],   b[7:0],   op)};
    end
endmodule
