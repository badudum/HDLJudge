module seq_div (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] dividend,
    input  wire [15:0] divisor,
    output reg         busy,
    output reg         done,
    output reg  [15:0] quotient,
    output reg  [15:0] remainder
);
    reg [15:0] rem, num, den, q;
    reg [4:0]  step;

    wire [16:0] shifted = {rem, num[15]};            // bring in the next dividend bit
    wire [16:0] diff    = shifted - {1'b0, den};
    wire        ge      = !diff[16];                 // shifted >= den
    wire [15:0] rem_n   = ge ? diff[15:0] : shifted[15:0];
    wire [15:0] q_n     = {q[14:0], ge};

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0; quotient <= 16'd0; remainder <= 16'd0;
        end else if (busy) begin
            rem  <= rem_n;
            q    <= q_n;
            num  <= num << 1;
            step <= step + 5'd1;
            if (step == 5'd15) begin
                busy      <= 1'b0;
                done      <= 1'b1;
                quotient  <= q_n;
                remainder <= rem_n;
            end
        end else if (start) begin
            busy <= 1'b1;
            rem  <= 16'd0;
            q    <= 16'd0;
            num  <= dividend;
            den  <= divisor;
            step <= 5'd0;
        end
    end
endmodule
