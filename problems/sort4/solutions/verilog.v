module sort4 (
    input  wire [7:0] in0, in1, in2, in3,
    output wire [7:0] out0, out1, out2, out3
);
    // compare-and-swap: {min, max}
    function [15:0] cas(input [7:0] a, input [7:0] b);
        cas = (a < b) ? {a, b} : {b, a};
    endfunction
    wire [7:0] a0, a1, a2, a3, b0, b1, b2, b3, c1, c2;
    assign {a0, a1} = cas(in0, in1);
    assign {a2, a3} = cas(in2, in3);
    assign {b0, b2} = cas(a0, a2);
    assign {b1, b3} = cas(a1, a3);
    assign {c1, c2} = cas(b1, b2);
    assign out0 = b0; assign out1 = c1; assign out2 = c2; assign out3 = b3;
endmodule
