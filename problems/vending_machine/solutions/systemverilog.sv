module vending (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] coin,
    output logic       dispense,
    output logic [5:0] change,
    output logic [5:0] credit
);
    logic [5:0] total;
    always_comb begin
        unique case (coin)
            2'd0: total = credit;
            2'd1: total = credit + 6'd5;
            2'd2: total = credit + 6'd10;
            2'd3: total = credit + 6'd25;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            {credit, dispense, change} <= '0;
        end else begin
            dispense <= total >= 30;
            change   <= (total >= 30) ? total - 6'd30 : '0;
            credit   <= (total >= 30) ? '0 : total;
        end
    end
endmodule
