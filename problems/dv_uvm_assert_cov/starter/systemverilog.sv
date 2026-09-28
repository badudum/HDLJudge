module hs_sva (
    input logic       clk,
    input logic       rst,
    input logic       req,
    input logic       gnt,
    input logic [3:0] id
);
    int cov_b2b = 0, cov_max_wait = 0;

    // TODO: 4 assertions reporting via `uvm_error with IDs HS_GNT_NO_REQ, HS_REQ_DROP, HS_ID_CHANGE, HS_TIMEOUT
    // TODO: 2 cover properties incrementing cov_b2b and cov_max_wait
endmodule
