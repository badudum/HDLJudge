module traffic_light (
    input  logic       clk,
    input  logic       rst,
    input  logic       car,
    output logic [1:0] main,
    output logic [1:0] side
);
    typedef enum logic [1:0] {MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW} state_t;
    localparam logic [1:0] RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;

    state_t     state;
    logic [2:0] timer;      // cycles spent in the state - 1 (saturates)

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= MAIN_GREEN;
            timer <= '0;
        end else begin
            unique case (state)
                MAIN_GREEN:  if (timer >= 5 && car) begin state <= MAIN_YELLOW; timer <= '0; end
                             else if (timer != 3'd7) timer <= timer + 1'b1;
                MAIN_YELLOW: if (timer == 1) begin state <= SIDE_GREEN;  timer <= '0; end
                             else timer <= timer + 1'b1;
                SIDE_GREEN:  if (timer == 3) begin state <= SIDE_YELLOW; timer <= '0; end
                             else timer <= timer + 1'b1;
                SIDE_YELLOW: if (timer == 1) begin state <= MAIN_GREEN;  timer <= '0; end
                             else timer <= timer + 1'b1;
            endcase
        end
    end

    assign main = (state == MAIN_GREEN)  ? GREEN  : (state == MAIN_YELLOW) ? YELLOW : RED;
    assign side = (state == SIDE_GREEN)  ? GREEN  : (state == SIDE_YELLOW) ? YELLOW : RED;
endmodule
