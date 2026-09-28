module delay4 (
    input  wire        clk,
    input  wire [7:0]  din,
    output wire [31:0] taps,
    output wire [7:0]  dout
);
    reg [7:0] s1, s2, s3, s4;

    always @(posedge clk) begin
        s1 = din;
        s2 = s1;
        s3 = s2;
        s4 = s3;
    end

    assign taps = {s4, s3, s2, s1};
    assign dout = s4;
endmodule
