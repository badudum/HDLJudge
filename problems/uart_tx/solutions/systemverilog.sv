module uart_tx (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       busy
);
    localparam int CLKS_PER_BIT = 4;
    logic [9:0] frame;
    logic [5:0] cnt;          // cycle within the frame, 0..39

    always_ff @(posedge clk) begin
        if (rst) begin
            busy <= 1'b0;
        end else if (busy) begin
            if (cnt == 10 * CLKS_PER_BIT - 1) busy <= 1'b0;
            cnt <= cnt + 1'b1;
        end else if (start) begin
            frame <= {1'b1, data, 1'b0};
            busy  <= 1'b1;
            cnt   <= '0;
        end
    end

    assign tx = busy ? frame[cnt / CLKS_PER_BIT] : 1'b1;
endmodule
