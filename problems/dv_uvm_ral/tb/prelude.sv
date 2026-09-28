`include "uvm_macros.svh"
import uvm_pkg::*;

// Register bus: single-cycle accesses. The driver fills `data` for reads.
class bus_item extends uvm_sequence_item;
    bit        write;
    bit [7:0]  addr;
    bit [31:0] data;
    `uvm_object_utils(bus_item)
    function new(string name = "bus_item"); super.new(name); endfunction
    function string convert2string(); return $sformatf("%s addr=0x%02h data=0x%08h", write ? "WR" : "RD", addr, data); endfunction
endclass
