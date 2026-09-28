`include "uvm_macros.svh"
import uvm_pkg::*;

interface stream_if (input logic clk);
    logic       rst;      // synchronous, active high (driven by the testbench)
    logic       valid;    // driver -> DUT
    logic [7:0] data;     // driver -> DUT
    logic       ready;    // DUT -> driver (random backpressure)
endinterface

class stream_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(stream_item)
    function new(string name = "stream_item"); super.new(name); endfunction
endclass
