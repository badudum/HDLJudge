module tag_compare (
    input  wire [19:0] tag,
    input  wire [79:0] way_tags,
    input  wire [3:0]  way_valid,
    output wire        hit,
    output reg  [1:0]  hit_way,
    output wire [3:0]  hit_onehot,
    output wire        multi_hit
);
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cmp
            assign hit_onehot[i] = way_valid[i] && (way_tags[20*i +: 20] == tag);
        end
    endgenerate

    assign hit       = |hit_onehot;
    assign multi_hit = (hit_onehot & (hit_onehot - 4'd1)) != 4'd0;

    always @(*) begin
        casez (hit_onehot)
            4'b???1: hit_way = 2'd0;
            4'b??10: hit_way = 2'd1;
            4'b?100: hit_way = 2'd2;
            4'b1000: hit_way = 2'd3;
            default: hit_way = 2'd0;
        endcase
    end
endmodule
