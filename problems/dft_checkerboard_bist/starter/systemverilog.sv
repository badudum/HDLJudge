module cb_bist (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic [7:0] mem_rdata,
    output logic [3:0] mem_addr,
    output logic       mem_we,
    output logic [7:0] mem_wdata,
    output logic       busy,
    output logic       done,
    output logic       fail
);

    // Your code here

endmodule
