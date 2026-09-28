module mavg4 (
    input  logic       clk,
    input  logic       rst,
    input  logic       valid_in,
    input  logic [7:0] din,
    output logic [7:0] dout
);
    logic [7:0] taps [4];         // the four samples currently in the window
    logic [9:0] acc;              // running sum of taps
    logic [9:0] next_acc;

    // new window = {din, taps[0], taps[1], taps[2]}: taps[3] drops out
    assign next_acc = acc + din - taps[3];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 4; i++) taps[i] <= '0;
            acc  <= '0;
            dout <= '0;
        end else if (valid_in) begin
            taps[0] <= din;
            for (int i = 1; i < 4; i++) taps[i] <= taps[i - 1];
            acc  <= next_acc;
            dout <= next_acc[9:2];
        end
    end
endmodule
