module req_ack_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire [7:0] data_in,
    output reg        ack,
    output reg  [7:0] data_out,
    output reg        strobe
);
    always @(posedge clk) begin
        strobe <= 1'b0;
        if (rst) begin
            ack      <= 1'b0;
            data_out <= 8'd0;
        end else if (!ack) begin
            if (req) begin
                ack      <= 1'b1;
                strobe   <= 1'b1;
                data_out <= data_in;       // fix 1: capture while req is high and data is valid
            end
        end else if (!req) begin           // fix 2: keep ack until the sender drops req
            ack <= 1'b0;
        end
    end
endmodule
