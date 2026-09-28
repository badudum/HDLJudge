module sar_ctrl (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire       cmp,
    output wire [7:0] dac,
    output reg        done,
    output reg  [7:0] result
);
    reg [7:0] code;
    reg [2:0] bitn;
    reg       busy;
    reg [7:0] next_code;

    assign dac = code;

    // decide the current bit from cmp, and set the next trial bit
    always @(*) begin
        next_code = code;
        if (!cmp) next_code[bitn] = 1'b0;
        if (bitn != 3'd0) next_code[bitn - 1] = 1'b1;
    end

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy   <= 1'b0;
            code   <= 8'd0;
            result <= 8'd0;
        end else if (!busy) begin
            if (start) begin
                busy <= 1'b1;
                code <= 8'h80;
                bitn <= 3'd7;
            end
        end else begin
            code <= next_code;
            if (bitn == 3'd0) begin
                busy   <= 1'b0;
                done   <= 1'b1;
                result <= next_code;
            end else begin
                bitn <= bitn - 3'd1;
            end
        end
    end
endmodule
