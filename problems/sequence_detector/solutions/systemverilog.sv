module seq_detect (
    input  logic clk,
    input  logic rst,
    input  logic din,
    output logic detected
);
    typedef enum logic [2:0] {S0, S1, S10, S101, S1011} state_t;
    state_t state, next;

    always_comb begin
        next = S0;
        case (state)
            S0:    if (din) next = S1;    else next = S0;
            S1:    if (din) next = S1;    else next = S10;
            S10:   if (din) next = S101;  else next = S0;
            S101:  if (din) next = S1011; else next = S10;
            S1011: if (din) next = S1;    else next = S10;
            default: next = S0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    assign detected = (state == S1011);
endmodule
