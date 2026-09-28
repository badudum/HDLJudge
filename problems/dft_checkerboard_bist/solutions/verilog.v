module cb_bist (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] mem_rdata,
    output reg  [3:0] mem_addr,
    output reg        mem_we,
    output reg  [7:0] mem_wdata,
    output reg        busy,
    output reg        done,
    output reg        fail
);
    reg  [5:0] k;                                     // {phase, addr}
    function [7:0] pat(input [5:0] kk);               // expected data for step kk
        pat = ((kk[2] ^ kk[0]) ? 8'hAA : 8'h55) ^ (kk[5] ? 8'hFF : 8'h00);
    endfunction
    wire [5:0] kn = k + 6'd1;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 0; k <= 0; fail <= 0; mem_we <= 0;
        end else if (busy) begin
            if (k[4] && mem_rdata != pat(k)) fail <= 1'b1;   // phases 1 and 3 read
            k <= kn;
            if (k == 6'd63) begin
                busy <= 1'b0; done <= 1'b1; mem_we <= 1'b0;
            end else begin
                mem_addr <= kn[3:0]; mem_we <= ~kn[4]; mem_wdata <= pat(kn);
            end
        end else if (start) begin
            busy <= 1'b1; k <= 6'd0; fail <= 1'b0;
            mem_addr <= 4'd0; mem_we <= 1'b1; mem_wdata <= 8'h55;
        end
    end
endmodule
