module refill_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire       miss,
    input  wire       dirty,
    input  wire [7:0] miss_line,
    input  wire [7:0] victim_line,
    input  wire       mem_ack,
    output wire       mem_req,
    output wire       mem_we,
    output wire [9:0] mem_addr,
    output wire       done
);
    localparam IDLE = 2'd0, WB = 2'd1, RF = 2'd2, DN = 2'd3;
    reg [1:0] state, beat;
    reg [7:0] ml, vl;

    assign mem_req  = (state == WB) || (state == RF);
    assign mem_we   = (state == WB);
    assign mem_addr = {(state == WB) ? vl : ml, beat};
    assign done     = (state == DN);

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (miss) begin
                          ml <= miss_line; vl <= victim_line; beat <= 2'd0;
                          state <= dirty ? WB : RF;
                      end
                WB, RF: if (mem_ack) begin
                          beat <= beat + 2'd1;
                          if (beat == 2'd3) state <= (state == WB) ? RF : DN;
                      end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
