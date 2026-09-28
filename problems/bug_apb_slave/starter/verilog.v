module apb_regs (
    input  wire        pclk,
    input  wire        presetn,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [3:0]  paddr,
    input  wire [31:0] pwdata,
    output reg  [31:0] prdata,
    output wire        pready
);
    reg [31:0] regs [0:3];
    wire [1:0] idx = paddr[1:0];

    assign pready = 1'b1;

    always @(posedge pclk) begin
        if (!presetn) begin
            regs[0] <= 32'd0;
            regs[1] <= 32'd0;
            regs[2] <= 32'd0;
            regs[3] <= 32'hC0DE_0001;
        end else if (psel && penable && pwrite) begin
            regs[idx] <= pwdata;
        end
    end

    always @(*) begin
        if (psel && !pwrite) prdata = regs[idx];
        else                 prdata = 32'd0;
    end
endmodule
