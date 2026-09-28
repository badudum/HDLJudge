module manchester_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [7:0] data,
    output reg        tx,
    output reg        busy
);
    reg [7:0] sh;
    reg [3:0] k;
    wire [3:0] kn = k + 4'd1;
    wire       bn = sh[3'd7 - kn[3:1]];

    always @(posedge clk) begin
        if (rst) begin
            busy <= 1'b0; tx <= 1'b0; k <= 4'd0;
        end else if (busy) begin
            k <= kn;
            if (k == 4'd15) begin busy <= 1'b0; tx <= 1'b0; end
            else            tx <= kn[0] ? bn : ~bn;
        end else if (load) begin
            busy <= 1'b1; sh <= data; k <= 4'd0; tx <= ~data[7];
        end
    end
endmodule
