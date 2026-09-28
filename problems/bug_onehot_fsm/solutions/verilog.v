module onehot_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire       go,
    input  wire       done,
    output reg  [3:0] state,
    output wire       busy
);
    localparam IDLE = 0, LOAD = 1, RUN = 2, FLUSH = 3;
    wire [3:0] next;

    assign next[IDLE]  = (state[IDLE] & ~go) | state[FLUSH];
    assign next[LOAD]  = state[IDLE] & go;
    assign next[RUN]   = state[LOAD] | (state[RUN] & ~done);    // fix 2: leave RUN on done
    assign next[FLUSH] = state[RUN] & done;

    always @(posedge clk) begin
        if (rst) state <= 4'b0001;                               // fix 1: reset makes IDLE hot
        else     state <= next;
    end

    assign busy = ~state[IDLE];
endmodule
