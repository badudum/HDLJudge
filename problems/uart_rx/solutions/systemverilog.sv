module uart_rx (
    input  logic       clk,
    input  logic       rst,
    input  logic       rx,
    output logic [7:0] data,
    output logic       valid,
    output logic       frame_err
);
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t     state;
    logic [2:0] phase;      // cycles until the next sample point
    logic [2:0] bitn;
    logic [7:0] sh;

    always_ff @(posedge clk) begin
        valid     <= 1'b0;
        frame_err <= 1'b0;
        if (rst) begin
            state <= IDLE;
            data  <= '0;
        end else begin
            unique case (state)
                IDLE:  if (!rx) begin state <= START; phase <= 3'd3; end
                START: if (phase != 0) phase <= phase - 1'b1;
                       else if (rx) state <= IDLE;
                       else begin state <= DATA; phase <= 3'd7; bitn <= '0; end
                DATA:  if (phase != 0) phase <= phase - 1'b1;
                       else begin
                           sh    <= {rx, sh[7:1]};
                           phase <= 3'd7;
                           bitn  <= bitn + 1'b1;
                           if (bitn == 3'd7) state <= STOP;
                       end
                STOP:  if (phase != 0) phase <= phase - 1'b1;
                       else begin
                           if (rx) begin data <= sh; valid <= 1'b1; end
                           else frame_err <= 1'b1;
                           state <= IDLE;
                       end
            endcase
        end
    end
endmodule
