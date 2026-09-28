module time_counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       tick_ms,
    input  logic       load,
    input  logic [9:0] ld_ms,
    input  logic [5:0] ld_sec,
    input  logic [5:0] ld_min,
    input  logic [4:0] ld_hr,
    output logic [9:0] ms,
    output logic [5:0] sec,
    output logic [5:0] min,
    output logic [4:0] hr
);

    // Your code here

endmodule
