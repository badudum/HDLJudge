module dirty_tracker (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] op,
    input  logic [2:0] index,
    output logic [7:0] valid,
    output logic [7:0] dirty,
    output logic       writeback,
    output logic [2:0] wb_index
);

    // Your code here

endmodule
