`include "uvm_macros.svh"
import uvm_pkg::*;

interface mul_if (input logic clk);
    logic        req;      // driver -> DUT: start (one-cycle pulse, only while !busy)
    logic [7:0]  a, b;     // operands, valid with req
    logic        busy;     // DUT -> driver: an operation is in progress
    logic        done;     // DUT -> driver: result valid (one-cycle pulse)
    logic [15:0] result;
endinterface

class mul_item extends uvm_sequence_item;
    rand bit [7:0] a, b;
    bit [15:0]     result;
    `uvm_object_utils(mul_item)
    function new(string name = "mul_item"); super.new(name); endfunction
    function string convert2string(); return $sformatf("a=%0d b=%0d result=%0d", a, b, result); endfunction
endclass
