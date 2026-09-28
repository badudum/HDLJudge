module jtag_tap (
    input  wire       tck,
    input  wire       trst,
    input  wire       tms,
    output reg  [3:0] state,
    output reg        shift_dr,
    output reg        shift_ir,
    output reg        capture_dr,
    output reg        update_dr,
    output reg        tlr
);

    // Your code here

endmodule
