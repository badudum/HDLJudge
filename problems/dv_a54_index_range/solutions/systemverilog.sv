module chk_index (
    input logic clk,
    input logic rst,
    input logic we,
    input logic re,
    input logic [3:0] addr
);
    a_range: assert property (@(posedge clk) disable iff (rst) (we || re) |-> addr < 4'd12) else $error("address out of range");
    a_excl:  assert property (@(posedge clk) disable iff (rst) !(we && re)) else $error("read and write together");
endmodule
