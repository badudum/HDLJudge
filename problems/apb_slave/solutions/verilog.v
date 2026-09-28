module apb_slave (
    input  wire        pclk,
    input  wire        presetn,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,
    input  wire [3:0]  pstrb,
    output reg  [31:0] prdata,
    output wire        pready,
    output wire        pslverr
);
    localparam [31:0] ID = 32'hA9B00001;
    reg [31:0] ctrl, data, wcount;

    wire access  = psel && penable;
    wire aligned = (paddr[1:0] == 2'b00);
    wire mapped  = aligned && (paddr <= 8'h0C);
    wire ro      = (paddr == 8'h08) || (paddr == 8'h0C);
    wire bad     = !mapped || (pwrite && ro);
    wire do_wr   = access && pwrite && !bad;

    assign pready  = 1'b1;
    assign pslverr = access && bad;

    integer i;
    always @(posedge pclk) begin
        if (!presetn) begin
            ctrl <= 0; data <= 0; wcount <= 0;
        end else if (do_wr) begin
            for (i = 0; i < 4; i = i + 1)
                if (pstrb[i]) begin
                    if (paddr == 8'h00) ctrl[8*i +: 8] <= pwdata[8*i +: 8];
                    else                data[8*i +: 8] <= pwdata[8*i +: 8];
                end
            wcount <= wcount + 1;
        end
    end

    always @(*) begin
        prdata = 32'd0;
        if (psel && !pwrite && aligned)
            case (paddr)
                8'h00: prdata = ctrl;
                8'h04: prdata = data;
                8'h08: prdata = ID;
                8'h0C: prdata = wcount;
                default: prdata = 32'd0;
            endcase
    end
endmodule
