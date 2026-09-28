module det1101 (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire found
);
    localparam S0 = 3'd0, S1 = 3'd1, S11 = 3'd2, S110 = 3'd3, S1101 = 3'd4;
    reg [2:0] state, next;

    always @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    always @(state) begin
        case (state)
            S0:      next = din ? S1    : S0;
            S1:      next = din ? S11   : S0;
            S11:     next = din ? S11   : S110;
            S110:    next = din ? S1101 : S0;
            S1101:   next = din ? S1    : S0;
            default: next = S0;
        endcase
    end

    assign found = (state == S1101);
endmodule
