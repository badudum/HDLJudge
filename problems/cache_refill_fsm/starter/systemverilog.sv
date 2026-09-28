module refill_fsm (
    input  logic       clk,
    input  logic       rst,
    input  logic       miss,
    input  logic       dirty,
    input  logic [7:0] miss_line,
    input  logic [7:0] victim_line,
    input  logic       mem_ack,
    output logic       mem_req,
    output logic       mem_we,
    output logic [9:0] mem_addr,
    output logic       done
);

    // Your code here

endmodule
