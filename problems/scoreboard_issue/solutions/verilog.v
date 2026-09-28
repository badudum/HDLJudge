module scoreboard (
    input  wire       clk,
    input  wire       rst,
    input  wire       issue_valid,
    input  wire [2:0] rd,
    input  wire [2:0] rs1,
    input  wire [2:0] rs2,
    input  wire       wb_valid,
    input  wire [2:0] wb_rd,
    output reg        issued,
    output reg  [7:0] pending
);
    wire [7:0] after_wb = pending & ~(wb_valid ? (8'd1 << wb_rd) : 8'd0) & 8'hFE;
    wire       hazard   = after_wb[rs1] | after_wb[rs2] | after_wb[rd];
    wire       go       = issue_valid && !hazard;

    always @(posedge clk) begin
        if (rst) begin
            pending <= 8'd0;
            issued  <= 1'b0;
        end else begin
            issued  <= go;
            pending <= (after_wb | (go ? (8'd1 << rd) : 8'd0)) & 8'hFE;
        end
    end
endmodule
