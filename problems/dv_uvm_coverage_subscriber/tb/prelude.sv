`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [1:0] {OP_ADD, OP_SUB, OP_AND, OP_XOR} alu_op_e;

class alu_item extends uvm_sequence_item;
    alu_op_e  op;
    bit [7:0] a, b;
    `uvm_object_utils(alu_item)
    function new(string name = "alu_item"); super.new(name); endfunction
endclass
