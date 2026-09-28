module edge_detect (
    input  logic clk,
    input  logic rst,
    input  logic din,
    output logic pulse
);
    logic prev;
    always_ff @(posedge clk) begin
        if (rst) begin
            prev  <= 1'b0;
            pulse <= 1'b0;
        end else begin
            prev  <= din;
            pulse <= din && !prev;
        end
    end
endmodule
