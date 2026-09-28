module cg_ctrl (
    input  wire        clk,
    input  wire        rst,
    input  wire        req,
    input  wire        force_on,
    output wire        cg_en,
    output wire        ready,
    output reg  [15:0] saved
);
    localparam OFF = 2'd0, WAKE = 2'd1, ON = 2'd2;
    reg [1:0] state, idle;

    assign cg_en = (state != OFF);
    assign ready = (state == ON);

    always @(posedge clk) begin
        if (rst) begin
            state <= OFF; idle <= 2'd0; saved <= 16'd0;
        end else begin
            case (state)
                OFF: begin
                    saved <= saved + 16'd1;
                    if (req || force_on) state <= WAKE;
                end
                WAKE: begin
                    state <= ON; idle <= 2'd0;
                end
                default: begin
                    if (req || force_on)  idle <= 2'd0;
                    else if (idle == 2'd2) begin state <= OFF; idle <= 2'd0; end
                    else                  idle <= idle + 2'd1;
                end
            endcase
        end
    end
endmodule
