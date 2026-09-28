module irq_ctrl (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] irq_in,
    input  wire       mask_we,
    input  wire [7:0] mask_data,
    input  wire       ack,
    output wire       irq,
    output reg  [2:0] id,
    output reg  [7:0] pending,
    output reg  [7:0] mask
);
    reg  [7:0] prev;
    wire [7:0] en = pending & mask;
    integer i;
    always @(*) begin
        id = 3'd0;
        for (i = 7; i >= 0; i = i - 1)
            if (en[i]) id = i;
    end
    assign irq = |en;
    wire [7:0] clr = (ack && irq) ? (8'd1 << id) : 8'd0;

    always @(posedge clk) begin
        if (rst) begin
            prev <= 0; pending <= 0; mask <= 0;
        end else begin
            pending <= (pending & ~clr) | (irq_in & ~prev);
            prev <= irq_in;
            if (mask_we) mask <= mask_data;
        end
    end
endmodule
