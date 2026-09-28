module rr_arbiter4 (
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] req,
    output logic [3:0] grant
);
    logic [1:0] ptr;
    logic [7:0] dbl;
    logic [3:0] rot, pick, gnt;
    logic [1:0] win;

    always_comb begin
        dbl  = {req, req} >> ptr;       // rotate so that ptr is at bit 0
        rot  = dbl[3:0];
        pick = rot & (~rot + 1'b1);     // isolate the lowest set bit
        gnt  = 4'((({pick, pick} << ptr) >> 4));   // rotate back
        win  = '0;
        for (int i = 0; i < 4; i++)
            if (gnt[i]) win = 2'(i);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            ptr   <= '0;
            grant <= '0;
        end else begin
            grant <= gnt;
            if (gnt != 0) ptr <= win + 1'b1;
        end
    end
endmodule
