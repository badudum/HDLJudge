module rename (
    input  wire       clk,
    input  wire       rst,
    input  wire       ren_valid,
    input  wire [2:0] rs1,
    input  wire [2:0] rs2,
    input  wire [2:0] rd,
    input  wire       has_rd,
    input  wire       free_valid,
    input  wire [3:0] free_preg,
    output reg        ren_ok,
    output reg        stall,
    output reg  [3:0] ps1,
    output reg  [3:0] ps2,
    output reg  [3:0] pd,
    output reg  [3:0] old_pd
);

    // Your code here

endmodule
