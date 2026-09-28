module rotator8 (
    input  logic [7:0] din,
    input  logic [2:0] amt,
    input  logic       dir,
    output logic [7:0] dout
);
    // log shifter: stages of 1, 2 and 4
    logic [7:0] s1, s2;
    always_comb begin
        if (dir) begin
            s1   = amt[0] ? {din[0],    din[7:1]} : din;
            s2   = amt[1] ? {s1[1:0],   s1[7:2]}  : s1;
            dout = amt[2] ? {s2[3:0],   s2[7:4]}  : s2;
        end else begin
            s1   = amt[0] ? {din[6:0], din[7]}    : din;
            s2   = amt[1] ? {s1[5:0],  s1[7:6]}   : s1;
            dout = amt[2] ? {s2[3:0],  s2[7:4]}   : s2;
        end
    end
endmodule
