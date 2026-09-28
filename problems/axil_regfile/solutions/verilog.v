module axil_regfile (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire [7:0]  awaddr,
    input  wire        awvalid,
    output wire        awready,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    input  wire        wvalid,
    output wire        wready,
    output reg  [1:0]  bresp,
    output reg         bvalid,
    input  wire        bready,
    input  wire [7:0]  araddr,
    input  wire        arvalid,
    output wire        arready,
    output reg  [31:0] rdata,
    output reg  [1:0]  rresp,
    output reg         rvalid,
    input  wire        rready
);
    reg [31:0] regs [0:7];

    // ---- write channel: collect AW and W in any order
    reg        aw_full, w_full;
    reg [7:0]  wa;
    reg [31:0] wd;
    reg [3:0]  ws;
    assign awready = !aw_full && !bvalid;
    assign wready  = !w_full  && !bvalid;
    wire do_write  = aw_full && w_full && !bvalid;

    always @(posedge aclk) begin
        if (!aresetn) begin
            aw_full <= 1'b0; w_full <= 1'b0; bvalid <= 1'b0; bresp <= 2'b00;
        end else begin
            if (awvalid && awready) begin aw_full <= 1'b1; wa <= awaddr; end
            if (wvalid && wready)   begin w_full  <= 1'b1; wd <= wdata; ws <= wstrb; end
            if (do_write) begin
                aw_full <= 1'b0; w_full <= 1'b0; bvalid <= 1'b1;
                bresp   <= (wa >= 8'h20) ? 2'b10 : 2'b00;
            end else if (bvalid && bready) begin
                bvalid <= 1'b0;
            end
        end
    end

    // ---- read channel
    assign arready = !rvalid;
    always @(posedge aclk) begin
        if (!aresetn) begin
            rvalid <= 1'b0; rresp <= 2'b00; rdata <= 32'd0;
        end else if (arvalid && arready) begin
            rvalid <= 1'b1; rdata <= (araddr >= 8'h20) ? 32'd0 : regs[araddr[4:2]]; rresp <= (araddr >= 8'h20) ? 2'b10 : 2'b00;
        end else if (rvalid && rready) begin
            rvalid <= 1'b0;
        end
    end

    integer i;
    always @(posedge aclk) begin
        if (!aresetn) begin
            for (i = 0; i < 8; i = i + 1) regs[i] <= 32'd0;
        end else if (do_write && wa < 8'h20) begin
            for (i = 0; i < 4; i = i + 1)
                if (ws[i]) regs[wa[4:2]][8*i +: 8] <= wd[8*i +: 8];
        end
    end
endmodule
