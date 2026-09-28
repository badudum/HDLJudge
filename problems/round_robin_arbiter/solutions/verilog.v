module rr_arbiter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] req,
    output reg  [3:0] grant
);
    reg  [1:0] ptr;
    reg  [3:0] next_grant;
    reg  [1:0] next_ptr;
    reg        found;
    integer    k;

    always @(*) begin
        next_grant = 4'd0;
        next_ptr   = ptr;
        found      = 1'b0;
        for (k = 0; k < 4; k = k + 1) begin
            if (!found && req[(ptr + k) % 4]) begin
                found      = 1'b1;
                next_grant = 4'd1 << ((ptr + k) % 4);
                next_ptr   = (ptr + k + 1) % 4;
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            ptr   <= 2'd0;
            grant <= 4'd0;
        end else begin
            ptr   <= next_ptr;
            grant <= next_grant;
        end
    end
endmodule
