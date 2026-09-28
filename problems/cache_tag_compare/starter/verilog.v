module tag_compare (
    input  wire [19:0] tag,
    input  wire [79:0] way_tags,
    input  wire [3:0]  way_valid,
    output reg         hit,
    output reg  [1:0]  hit_way,
    output reg  [3:0]  hit_onehot,
    output reg         multi_hit
);

    // Your code here

endmodule
