module thread_mask (
    input  wire [7:0] active,
    input  wire [7:0] cond,
    output wire [7:0] taken,
    output wire [7:0] not_taken,
    output wire       divergent,
    output reg  [2:0] first_lane,
    output wire       any_active
);
    integer i;
    assign taken      = active & cond;
    assign not_taken  = active & ~cond;
    assign divergent  = (|taken) & (|not_taken);
    assign any_active = |active;

    always @(*) begin
        first_lane = 3'd0;
        for (i = 7; i >= 0; i = i - 1)
            if (active[i]) first_lane = i;
    end
endmodule
