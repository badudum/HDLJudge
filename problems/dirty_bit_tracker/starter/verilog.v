module dirty_tracker (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] op,
    input  wire [2:0] index,
    output reg  [7:0] valid,
    output reg  [7:0] dirty,
    output reg        writeback,
    output reg  [2:0] wb_index
);

    // Your code here

endmodule
