module prio_enc8 (
    input  wire [7:0] req,
    output reg  [2:0] idx,
    output wire       valid
);
    integer i;
    assign valid = |req;

    always @(*) begin
        idx = 3'd0;
        for (i = 0; i < 8; i = i + 1)
            if (req[i]) idx = i;
    end
endmodule
