module bcd_add (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [4:0] bin = a + b + cin;
    assign cout = bin > 5'd9;
    wire [4:0] adj = cout ? bin + 5'd6 : bin;
    assign sum  = adj[3:0];
endmodule
