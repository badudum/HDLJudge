module hazard_unit (
    input  wire [4:0] id_rs1,
    input  wire [4:0] id_rs2,
    input  wire       id_uses_rs1,
    input  wire       id_uses_rs2,
    input  wire [4:0] ex_rd,
    input  wire       ex_mem_read,
    input  wire       ex_branch_taken,
    output wire       stall,
    output wire       id_ex_bubble,
    output wire       if_id_flush
);
    wire load_use = ex_mem_read && (ex_rd != 5'd0) &&
                    ((id_uses_rs1 && ex_rd == id_rs1) || (id_uses_rs2 && ex_rd == id_rs2));

    assign stall        = load_use && !ex_branch_taken;
    assign id_ex_bubble = load_use || ex_branch_taken;
    assign if_id_flush  = ex_branch_taken;
endmodule
