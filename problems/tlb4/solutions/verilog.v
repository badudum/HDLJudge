module tlb4 (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] vpn,
    output wire       hit,
    output reg  [7:0] ppn,
    input  wire       fill,
    input  wire [7:0] fill_vpn,
    input  wire [7:0] fill_ppn,
    input  wire       flush
);
    reg [3:0] v;
    reg [7:0] tag [0:3];
    reg [7:0] pn  [0:3];
    reg [1:0] ptr;
    wire [3:0] m  = {v[3] && tag[3] == vpn, v[2] && tag[2] == vpn, v[1] && tag[1] == vpn, v[0] && tag[0] == vpn};
    wire [3:0] fm = {v[3] && tag[3] == fill_vpn, v[2] && tag[2] == fill_vpn, v[1] && tag[1] == fill_vpn, v[0] && tag[0] == fill_vpn};
    assign hit = |m;
    always @(*) begin
        ppn = 8'd0;
        if (m[0]) ppn = pn[0];
        if (m[1]) ppn = pn[1];
        if (m[2]) ppn = pn[2];
        if (m[3]) ppn = pn[3];
    end
    reg [1:0] slot;
    reg       use_ptr;
    always @(*) begin
        use_ptr = 1'b0;
        if      (fm[0]) slot = 2'd0;
        else if (fm[1]) slot = 2'd1;
        else if (fm[2]) slot = 2'd2;
        else if (fm[3]) slot = 2'd3;
        else if (!v[0]) slot = 2'd0;
        else if (!v[1]) slot = 2'd1;
        else if (!v[2]) slot = 2'd2;
        else if (!v[3]) slot = 2'd3;
        else begin slot = ptr; use_ptr = 1'b1; end
    end
    always @(posedge clk) begin
        if (rst) begin
            v <= 4'd0; ptr <= 2'd0;
        end else if (flush) begin
            v <= 4'd0;
        end else if (fill) begin
            v[slot] <= 1'b1; tag[slot] <= fill_vpn; pn[slot] <= fill_ppn;
            if (use_ptr) ptr <= ptr + 2'd1;
        end
    end
endmodule
