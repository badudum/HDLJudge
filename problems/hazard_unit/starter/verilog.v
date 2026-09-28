module hazard_unit (
    input  wire [4:0] id_rs1,
    input  wire [4:0] id_rs2,
    input  wire       id_uses_rs1,
    input  wire       id_uses_rs2,
    input  wire [4:0] ex_rd,
    input  wire       ex_mem_read,
    input  wire       ex_branch_taken,
    output reg        stall,
    output reg        id_ex_bubble,
    output reg        if_id_flush
);

    // Your code here

endmodule
