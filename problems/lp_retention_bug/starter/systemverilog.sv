module ret_counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       pwr_on,
    input  logic       save,
    input  logic       restore,
    input  logic       en,
    output logic [7:0] count_out
);
    logic [7:0] count, shadow;

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 8'd0; shadow <= 8'd0;
        end else begin
            if (save) shadow <= count;
            if (!pwr_on)      count <= 8'd0;
            else if (en)      count <= count + 8'd1;
            else if (restore) count <= shadow;
        end
    end
    assign count_out = pwr_on ? count : 8'hFF;
endmodule
