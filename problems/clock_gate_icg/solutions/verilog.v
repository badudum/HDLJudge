module icg (
    input  wire clk,
    input  wire en,
    input  wire test_en,
    output wire gclk
);
    reg en_l;
    always @(*)
        if (!clk) en_l = en | test_en;     // transparent while clk is low
    assign gclk = clk & en_l;
endmodule
