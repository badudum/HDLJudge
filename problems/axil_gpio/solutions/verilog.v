module axil_gpio (
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
    input  wire        rready,
    input  wire [7:0]  gpio_in,
    output reg  [7:0]  gpio_out,
    output reg  [7:0]  gpio_oe
);
    reg [7:0] s1, s2;

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
                bresp   <= 2'b00;
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
            rvalid <= 1'b1; rdata <= (araddr == 8'h00) ? {24'd0, gpio_out} : (araddr == 8'h04) ? {24'd0, gpio_oe} : (araddr == 8'h08) ? {24'd0, s2} : 32'd0; rresp <= 2'b00;
        end else if (rvalid && rready) begin
            rvalid <= 1'b0;
        end
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            gpio_out <= 8'd0; gpio_oe <= 8'd0; s1 <= 8'd0; s2 <= 8'd0;
        end else begin
            s1 <= gpio_in; s2 <= s1;
            if (do_write && ws[0]) begin
                if (wa == 8'h00) gpio_out <= wd[7:0];
                if (wa == 8'h04) gpio_oe  <= wd[7:0];
                if (wa == 8'h0C) gpio_out <= gpio_out ^ wd[7:0];
            end
        end
    end
endmodule
