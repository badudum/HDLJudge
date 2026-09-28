module cdc_handshake (
    input  wire       clk_a,
    input  wire       rst_a,
    input  wire       a_valid,
    input  wire [7:0] a_data,
    output wire       a_ready,
    input  wire       clk_b,
    input  wire       rst_b,
    output reg        b_valid,
    output reg  [7:0] b_data
);
    // ---- domain A
    reg       req, busy, ack_s1, ack_s2;
    reg [7:0] hold;
    reg       ack;                       // domain B
    assign a_ready = !busy;

    always @(posedge clk_a) begin
        if (rst_a) begin
            req <= 1'b0; busy <= 1'b0; ack_s1 <= 1'b0; ack_s2 <= 1'b0;
        end else begin
            ack_s1 <= ack; ack_s2 <= ack_s1;
            if (!busy && a_valid) begin
                hold <= a_data; req <= 1'b1; busy <= 1'b1;
            end else if (busy && req && ack_s2) begin
                req <= 1'b0;
            end else if (busy && !req && !ack_s2) begin
                busy <= 1'b0;
            end
        end
    end

    // ---- domain B
    reg req_s1, req_s2;
    always @(posedge clk_b) begin
        if (rst_b) begin
            req_s1 <= 1'b0; req_s2 <= 1'b0; ack <= 1'b0; b_valid <= 1'b0;
        end else begin
            req_s1 <= req; req_s2 <= req_s1;
            b_valid <= 1'b0;
            if (req_s2 && !ack) begin
                b_data <= hold; b_valid <= 1'b1; ack <= 1'b1;
            end else if (!req_s2 && ack) begin
                ack <= 1'b0;
            end
        end
    end
endmodule
