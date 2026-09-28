module traffic_light (
    input  wire       clk,
    input  wire       rst,
    input  wire       car,
    output reg  [1:0] main,
    output reg  [1:0] side
);
    localparam MG = 2'd0, MY = 2'd1, SG = 2'd2, SY = 2'd3;
    localparam RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;

    reg [1:0] state;
    reg [3:0] timer;          // cycles already spent in the state, minus one

    always @(posedge clk) begin
        if (rst) begin
            state <= MG;
            timer <= 4'd0;
        end else begin
            case (state)
                MG: if (timer >= 4'd5 && car) begin state <= MY; timer <= 4'd0; end
                    else if (timer != 4'd15) timer <= timer + 4'd1;
                MY: if (timer == 4'd1) begin state <= SG; timer <= 4'd0; end
                    else timer <= timer + 4'd1;
                SG: if (timer == 4'd3) begin state <= SY; timer <= 4'd0; end
                    else timer <= timer + 4'd1;
                default: if (timer == 4'd1) begin state <= MG; timer <= 4'd0; end
                         else timer <= timer + 4'd1;
            endcase
        end
    end

    always @(*) begin
        case (state)
            MG:      begin main = GREEN;  side = RED;    end
            MY:      begin main = YELLOW; side = RED;    end
            SG:      begin main = RED;    side = GREEN;  end
            default: begin main = RED;    side = YELLOW; end
        endcase
    end
endmodule
