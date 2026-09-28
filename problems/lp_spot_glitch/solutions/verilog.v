module gated_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output wire       gclk,
    output reg  [7:0] count
);
    // Power saving: only clock the counter when it is enabled.
    reg en_l;
    always @(*) if (!clk) en_l = en;       // latch: enable is frozen while clk is high
    assign gclk = clk & en_l;

    always @(posedge gclk or posedge rst)
        if (rst) count <= 8'd0;
        else     count <= count + 8'd1;
endmodule
