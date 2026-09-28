`include "uvm_macros.svh"
import uvm_pkg::*;

class pkt extends uvm_sequence_item;
    bit [15:0] id;
    bit [31:0] payload;
    `uvm_object_utils(pkt)
    function new(string name = "pkt"); super.new(name); endfunction
    function string convert2string(); return $sformatf("id=%0d payload=0x%08h", id, payload); endfunction
endclass
