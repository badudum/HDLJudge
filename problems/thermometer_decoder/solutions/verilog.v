module therm2bin (
    input  wire [14:0] t,
    output reg  [3:0]  count,
    output wire        err
);
    integer i;
    wire [15:0] t16 = {1'b0, t};

    assign err = (t16 & (t16 + 16'd1)) != 16'd0;

    always @(*) begin
        count = 4'd0;
        for (i = 0; i < 15; i = i + 1)
            if (t[i]) count = i + 1;
    end
endmodule
