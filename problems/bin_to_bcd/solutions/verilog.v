module bin2bcd (
    input  wire [7:0]  bin,
    output wire [11:0] bcd
);
    reg [19:0] s;          // {hundreds, tens, ones, binary}
    integer i;

    always @(*) begin
        s = {12'd0, bin};
        for (i = 0; i < 8; i = i + 1) begin
            if (s[11:8]  >= 4'd5) s[11:8]  = s[11:8]  + 4'd3;
            if (s[15:12] >= 4'd5) s[15:12] = s[15:12] + 4'd3;
            if (s[19:16] >= 4'd5) s[19:16] = s[19:16] + 4'd3;
            s = s << 1;
        end
    end

    assign bcd = s[19:8];
endmodule
