module mshr4 (
    input  logic       clk,
    input  logic       rst,
    input  logic       miss_valid,
    input  logic [7:0] miss_addr,
    input  logic       resp_valid,
    input  logic [1:0] resp_id,
    output logic       mem_req,
    output logic [1:0] mem_id,
    output logic [7:0] mem_addr,
    output logic       merged,
    output logic [1:0] merge_id,
    output logic       stall,
    output logic [3:0] valid_mask
);

    // Your code here

endmodule
