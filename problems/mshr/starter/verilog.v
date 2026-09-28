module mshr4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       miss_valid,
    input  wire [7:0] miss_addr,
    input  wire       resp_valid,
    input  wire [1:0] resp_id,
    output reg        mem_req,
    output reg  [1:0] mem_id,
    output reg  [7:0] mem_addr,
    output reg        merged,
    output reg  [1:0] merge_id,
    output reg        stall,
    output reg  [3:0] valid_mask
);

    // Your code here

endmodule
