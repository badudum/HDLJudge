module seq_mult (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg         busy,
    output reg         done,
    output reg  [15:0] product
);
    reg [15:0] acc, mcand;
    reg [7:0]  mplier;
    reg [3:0]  step;
    wire [15:0] acc_next = mplier[0] ? acc + mcand : acc;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy    <= 1'b0;
            product <= 16'd0;
        end else if (busy) begin
            acc    <= acc_next;
            mcand  <= mcand << 1;
            mplier <= mplier >> 1;
            step   <= step + 4'd1;
            if (step == 4'd7) begin
                busy    <= 1'b0;
                done    <= 1'b1;
                product <= acc_next;
            end
        end else if (start) begin
            busy   <= 1'b1;
            acc    <= 16'd0;
            mcand  <= {8'd0, a};
            mplier <= b;
            step   <= 4'd0;
        end
    end
endmodule
