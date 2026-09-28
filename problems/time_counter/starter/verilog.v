module time_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick_ms,
    input  wire       load,
    input  wire [9:0] ld_ms,
    input  wire [5:0] ld_sec,
    input  wire [5:0] ld_min,
    input  wire [4:0] ld_hr,
    output reg  [9:0] ms,
    output reg  [5:0] sec,
    output reg  [5:0] min,
    output reg  [4:0] hr
);

    // Your code here

endmodule
