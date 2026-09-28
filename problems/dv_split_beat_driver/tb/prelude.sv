interface beat_if (input logic clk);
    logic       valid;
    logic       last;
    logic [7:0] data;
    logic       ready;
endinterface
