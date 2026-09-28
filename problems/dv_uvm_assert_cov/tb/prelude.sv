`include "uvm_macros.svh"
import uvm_pkg::*;
// No types needed: your module is instantiated as
//   hs_sva u_sva (.clk(clk), .rst(rst), .req(req), .gnt(gnt), .id(id));
// and the hidden UVM test reads u_sva.cov_b2b / u_sva.cov_max_wait and the UVM report server.
