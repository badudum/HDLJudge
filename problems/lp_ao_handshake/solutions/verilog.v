module ao_ctrl (
    input  wire clk,
    input  wire rst,
    input  wire sleep_req,
    input  wire wake_irq,
    input  wire pmu_ack,
    output wire pmu_req,
    output wire asleep,
    output reg  irq_out
);
    localparam RUN = 2'd0, REQ_OFF = 2'd1, SLEEP = 2'd2, REQ_ON = 2'd3;
    reg [1:0] state;
    reg       pend;

    assign pmu_req = (state == REQ_OFF) || (state == SLEEP);
    assign asleep  = (state == SLEEP);

    always @(posedge clk) begin
        if (rst) begin
            state <= RUN; pend <= 1'b0; irq_out <= 1'b0;
        end else begin
            irq_out <= 1'b0;
            case (state)
                RUN:
                    if (wake_irq)       irq_out <= 1'b1;
                    else if (sleep_req) state <= REQ_OFF;
                REQ_OFF: begin
                    if (wake_irq) pend <= 1'b1;
                    if (pmu_ack)  state <= (pend || wake_irq) ? REQ_ON : SLEEP;
                end
                SLEEP:
                    if (wake_irq) begin state <= REQ_ON; pend <= 1'b1; end
                default: begin
                    if (!pmu_ack) begin
                        state <= RUN; irq_out <= pend || wake_irq; pend <= 1'b0;
                    end else if (wake_irq) pend <= 1'b1;
                end
            endcase
        end
    end
endmodule
