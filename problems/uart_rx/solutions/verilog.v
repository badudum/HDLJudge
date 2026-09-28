module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg  [7:0] data,
    output reg        valid,
    output reg        frame_err
);
    reg       busy;
    reg [6:0] k;          // edges since the start bit was detected
    reg [7:0] sh;
    wire [6:0] kn = k + 7'd1;

    always @(posedge clk) begin
        valid     <= 1'b0;
        frame_err <= 1'b0;
        if (rst) begin
            busy <= 1'b0;
            data <= 8'd0;
        end else if (!busy) begin
            if (!rx) begin
                busy <= 1'b1;
                k    <= 7'd0;
            end
        end else begin
            k <= kn;
            if (kn == 7'd4) begin
                if (rx) busy <= 1'b0;                     // glitch
            end else if (kn >= 7'd12 && kn <= 7'd68 && kn[2:0] == 3'd4) begin
                sh <= {rx, sh[7:1]};                      // data bits, LSB first
            end else if (kn == 7'd76) begin
                if (rx) begin
                    data  <= sh;
                    valid <= 1'b1;
                end else begin
                    frame_err <= 1'b1;
                end
                busy <= 1'b0;
            end
        end
    end
endmodule
