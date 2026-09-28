module refill_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire       miss,
    input  wire       dirty,
    input  wire [7:0] miss_line,
    input  wire [7:0] victim_line,
    input  wire       mem_ack,
    output reg        mem_req,
    output reg        mem_we,
    output reg  [9:0] mem_addr,
    output reg        done
);

    // Your code here

endmodule
