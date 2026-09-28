module plru8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       touch,
    input  wire [2:0] way,
    output wire [2:0] victim,
    output reg  [6:0] bits
);
    // victim: follow the bits from the root
    wire       v2 = bits[0];
    wire       v1 = v2 ? bits[2] : bits[1];
    wire [2:0] n3 = 3'd3 + {v2, v1};
    wire       v0 = bits[n3];
    assign victim = {v2, v1, v0};

    always @(posedge clk) begin
        if (rst) begin
            bits <= 7'd0;
        end else if (touch) begin
            bits[0]              <= !way[2];
            bits[1 + way[2]]     <= !way[1];
            bits[3 + way[2:1]]   <= !way[0];
        end
    end
endmodule
