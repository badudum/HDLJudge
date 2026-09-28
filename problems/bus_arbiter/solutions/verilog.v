module bus_arb (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] req,
    input  wire [2:0] lock,
    output reg  [2:0] gnt,
    output reg  [1:0] owner,
    output wire       busy
);
    wire keep = |(gnt & req & lock);             // current owner is in a locked sequence

    always @(posedge clk) begin
        if (rst)        gnt <= 3'b000;
        else if (!keep) gnt <= req[0] ? 3'b001 : req[1] ? 3'b010 : req[2] ? 3'b100 : 3'b000;
    end

    always @(*) begin
        case (gnt)
            3'b010:  owner = 2'd1;
            3'b100:  owner = 2'd2;
            default: owner = 2'd0;
        endcase
    end
    assign busy = |gnt;
endmodule
