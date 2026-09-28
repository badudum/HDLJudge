module jtag_tap (
    input  wire       tck,
    input  wire       trst,
    input  wire       tms,
    output reg  [3:0] state,
    output wire       shift_dr,
    output wire       shift_ir,
    output wire       capture_dr,
    output wire       update_dr,
    output wire       tlr
);
    localparam TLR = 4'hF, RTI = 4'hC,
               SEL_DR = 4'h7, CAP_DR = 4'h6, SH_DR = 4'h2, EX1_DR = 4'h1,
               PAU_DR = 4'h3, EX2_DR = 4'h0, UPD_DR = 4'h5,
               SEL_IR = 4'h4, CAP_IR = 4'hE, SH_IR = 4'hA, EX1_IR = 4'h9,
               PAU_IR = 4'hB, EX2_IR = 4'h8, UPD_IR = 4'hD;

    always @(posedge tck) begin
        if (trst) state <= TLR;
        else case (state)
            TLR:    state <= tms ? TLR    : RTI;
            RTI:    state <= tms ? SEL_DR : RTI;
            SEL_DR: state <= tms ? SEL_IR : CAP_DR;
            CAP_DR: state <= tms ? EX1_DR : SH_DR;
            SH_DR:  state <= tms ? EX1_DR : SH_DR;
            EX1_DR: state <= tms ? UPD_DR : PAU_DR;
            PAU_DR: state <= tms ? EX2_DR : PAU_DR;
            EX2_DR: state <= tms ? UPD_DR : SH_DR;
            UPD_DR: state <= tms ? SEL_DR : RTI;
            SEL_IR: state <= tms ? TLR    : CAP_IR;
            CAP_IR: state <= tms ? EX1_IR : SH_IR;
            SH_IR:  state <= tms ? EX1_IR : SH_IR;
            EX1_IR: state <= tms ? UPD_IR : PAU_IR;
            PAU_IR: state <= tms ? EX2_IR : PAU_IR;
            EX2_IR: state <= tms ? UPD_IR : SH_IR;
            UPD_IR: state <= tms ? SEL_DR : RTI;
            default: state <= TLR;
        endcase
    end

    assign shift_dr   = (state == SH_DR);
    assign shift_ir   = (state == SH_IR);
    assign capture_dr = (state == CAP_DR);
    assign update_dr  = (state == UPD_DR);
    assign tlr        = (state == TLR);
endmodule
