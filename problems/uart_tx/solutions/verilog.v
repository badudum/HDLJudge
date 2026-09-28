module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [7:0] data,
    output wire       tx,
    output reg        busy
);
    reg [9:0] sh;         // {stop, data, start}, shifted out LSB first
    reg [1:0] tick;       // cycle within the current bit
    reg [3:0] bitn;       // bit index 0..9

    assign tx = busy ? sh[0] : 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            busy <= 1'b0;
        end else if (busy) begin
            if (tick == 2'd3) begin
                tick <= 2'd0;
                sh   <= {1'b1, sh[9:1]};
                if (bitn == 4'd9) busy <= 1'b0;
                else              bitn <= bitn + 4'd1;
            end else begin
                tick <= tick + 2'd1;
            end
        end else if (start) begin
            sh   <= {1'b1, data, 1'b0};
            busy <= 1'b1;
            tick <= 2'd0;
            bitn <= 4'd0;
        end
    end
endmodule
