module gated_counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       en,
    output logic       gclk,
    output logic [7:0] count
);
    // Power saving: only clock the counter when it is enabled.
    assign gclk = clk & en;

    always_ff @(posedge gclk or posedge rst)
        if (rst) count <= 8'd0;
        else     count <= count + 8'd1;
endmodule
