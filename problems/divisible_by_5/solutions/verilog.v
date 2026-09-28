module div5 (
    input  wire [15:0] x,
    output wire        d5
);
    // 16 = 1 (mod 5): x = sum of its hex digits (mod 5)
    wire [5:0] s1 = x[3:0] + x[7:4] + x[11:8] + x[15:12];   // <= 60
    wire [4:0] s2 = s1[3:0] + s1[5:4];                       // <= 18
    assign d5 = (s2 == 5'd0) || (s2 == 5'd5) || (s2 == 5'd10) || (s2 == 5'd15);
endmodule
