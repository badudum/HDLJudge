module sar_ctrl (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic       cmp,
    output logic [7:0] dac,
    output logic       done,
    output logic [7:0] result
);
    logic [7:0] code, mask;       // mask: one-hot bit under test (0 when idle)

    assign dac = code;

    always_ff @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            code   <= '0;
            mask   <= '0;
            result <= '0;
        end else if (mask == '0) begin
            if (start) begin
                code <= 8'h80;
                mask <= 8'h80;
            end
        end else begin
            // keep or drop the bit under test, then try the next one
            code <= (cmp ? code : code & ~mask) | (mask >> 1);
            mask <= mask >> 1;
            if (mask[0]) begin
                done   <= 1'b1;
                result <= cmp ? code : code & ~mask;
            end
        end
    end
endmodule
