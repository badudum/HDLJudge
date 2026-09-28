module bsr4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       capture_dr,
    input  wire       shift_dr,
    input  wire       update_dr,
    input  wire       mode,
    input  wire       scan_in,
    input  wire [3:0] data_in,
    output wire [3:0] data_out,
    output wire       scan_out
);
    reg [3:0] cap, upd;
    always @(posedge clk) begin
        if (rst) begin
            cap <= 4'd0; upd <= 4'd0;
        end else if (capture_dr) cap <= data_in;
        else if (shift_dr)       cap <= {cap[2:0], scan_in};
        else if (update_dr)      upd <= cap;
    end
    assign scan_out = cap[3];
    assign data_out = mode ? upd : data_in;
endmodule
