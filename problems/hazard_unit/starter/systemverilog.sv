module hazard_unit (
    input  logic [4:0] id_rs1,
    input  logic [4:0] id_rs2,
    input  logic       id_uses_rs1,
    input  logic       id_uses_rs2,
    input  logic [4:0] ex_rd,
    input  logic       ex_mem_read,
    input  logic       ex_branch_taken,
    output logic       stall,
    output logic       id_ex_bubble,
    output logic       if_id_flush
);

    // Your code here

endmodule
