module drowsy_array (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire       we,
    input  wire [2:0] idx,
    input  wire [7:0] wdata,
    output reg        ready,
    output reg  [7:0] rdata,
    output reg  [7:0] drowsy,
    output reg  [7:0] wakeups
);
    reg [7:0] data [0:7];
    reg [3:0] cyc;
    wire      is_dz = drowsy[idx];
    wire [7:0] wake = (req && is_dz) ? (8'd1 << idx) : 8'd0;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) data[i] <= 8'd0;
            drowsy <= 8'hFF; cyc <= 4'd0; wakeups <= 8'd0; ready <= 1'b0;
        end else begin
            ready <= req && !is_dz;
            if (req && !is_dz) begin
                if (we) data[idx] <= wdata;
                else    rdata <= data[idx];
            end
            if (req && is_dz) wakeups <= wakeups + 8'd1;
            cyc    <= cyc + 4'd1;
            drowsy <= (cyc == 4'd15) ? 8'hFF : (drowsy & ~wake);
        end
    end
endmodule
