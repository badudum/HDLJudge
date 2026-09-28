module forwarding_unit (
    input  wire [4:0] ex_rs1,
    input  wire [4:0] ex_rs2,
    input  wire [4:0] mem_rd,
    input  wire       mem_reg_write,
    input  wire [4:0] wb_rd,
    input  wire       wb_reg_write,
    output wire [1:0] fwd_a,
    output wire [1:0] fwd_b
);
    // Everything the function reads is an argument: a continuous assignment only
    // re-evaluates a function call when one of its arguments changes.
    function [1:0] sel(input [4:0] rs, input [4:0] mrd, input mw, input [4:0] wrd, input ww);
        if (mw && mrd != 5'd0 && mrd == rs)      sel = 2'b10;
        else if (ww && wrd != 5'd0 && wrd == rs) sel = 2'b01;
        else                                      sel = 2'b00;
    endfunction

    assign fwd_a = sel(ex_rs1, mem_rd, mem_reg_write, wb_rd, wb_reg_write);
    assign fwd_b = sel(ex_rs2, mem_rd, mem_reg_write, wb_rd, wb_reg_write);
endmodule
