module crc8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       init,
    input  wire       valid,
    input  wire [7:0] data,
    output reg  [7:0] crc
);
    reg [7:0] c;
    integer i;
    always @(*) begin
        c = crc;
        for (i = 0; i < 8; i = i + 1)
            c = {c[6:0], 1'b0} ^ ((c[7] ^ data[i]) ? 8'h07 : 8'h00);
    end
    always @(posedge clk)
        if (rst)        crc <= 8'h00;
        else if (valid) crc <= c;
        else if (init)  crc <= 8'h00;
endmodule
