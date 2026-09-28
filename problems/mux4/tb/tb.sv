`timescale 1ns/1ps
module tb;
    reg  [7:0] a, b, c, d;
    reg  [1:0] sel;
    wire [7:0] y;
    reg  [7:0] exp_y;
    integer i, s, errors, seed;

    mux4 dut (.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        seed = 7;
        for (s = 0; s < 4; s = s + 1) begin
            errors = 0;
            for (i = 0; i < 64; i = i + 1) begin
                a = $random(seed); b = $random(seed);
                c = $random(seed); d = $random(seed);
                sel = s;
                #5;
                case (sel)
                    2'd0: exp_y = a;
                    2'd1: exp_y = b;
                    2'd2: exp_y = c;
                    default: exp_y = d;
                endcase
                if (y !== exp_y) begin
                    if (errors == 0)
                        $display("FAIL: sel=%0d  a=%h b=%h c=%h d=%h -> expected y=%h, got %h",
                                 sel, a, b, c, d, exp_y, y);
                    errors = errors + 1;
                end
                #5;
            end
            if (errors == 0) $display("PASS: sel=%0d selects the right input (64 random vectors)", s);
        end
        // output must react to a change of sel alone (no clock, no stale value)
        a = 8'h11; b = 8'h22; c = 8'h33; d = 8'h44; sel = 0; #5;
        errors = 0;
        for (s = 0; s < 4; s = s + 1) begin
            sel = s; #1;
            if (y !== (8'h11 * (s + 1))) errors = errors + 1;
        end
        if (errors == 0) $display("PASS: output follows sel changes immediately");
        else $display("FAIL: output follows sel changes immediately (%0d mismatches)", errors);
        $display("TB_DONE");
        $finish;
    end
endmodule
