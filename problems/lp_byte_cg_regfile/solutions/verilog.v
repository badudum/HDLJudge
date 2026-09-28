module byte_rf (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,
    input  wire [1:0]  waddr,
    input  wire [3:0]  wbe,
    input  wire [31:0] wdata,
    input  wire [1:0]  raddr,
    output wire [31:0] rdata,
    output wire [15:0] cg_en
);
    reg [31:0] regs [0:3];
    genvar r, b;
    generate
        for (r = 0; r < 4; r = r + 1) begin : g_reg
            for (b = 0; b < 4; b = b + 1) begin : g_byte
                assign cg_en[4*r + b] = we && (waddr == r) && wbe[b];
                always @(posedge clk)
                    if (rst)                 regs[r][8*b +: 8] <= 8'd0;
                    else if (cg_en[4*r + b]) regs[r][8*b +: 8] <= wdata[8*b +: 8];
            end
        end
    endgenerate
    assign rdata = regs[raddr];
endmodule
