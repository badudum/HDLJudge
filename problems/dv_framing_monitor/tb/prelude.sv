interface byte_if (input logic clk);
    logic       valid;
    logic [7:0] data;
endinterface

class frame;
    bit [7:0] payload[$];
endclass
