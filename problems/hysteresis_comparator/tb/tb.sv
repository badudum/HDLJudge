`timescale 1ns/1ps
module tb;
    real  vp = 0.0, vn = 0.5;
    wire  q1, q2;
    reg   m1, m2;
    integer i, errors;
    reg [8*200-1:0] detail;
    real  vd;

    hyst_comp                  dut1 (.vp(vp), .vn(vn), .q(q1));
    hyst_comp #(.VH(0.4))      dut2 (.vp(vp), .vn(vn), .q(q2));

    task start_test;
        begin errors = 0; detail = ""; end
    endtask

    task end_test(input [8*80-1:0] name);
        begin
            if (errors == 0) $display("PASS: %0s", name);
            else             $display("FAIL: %0s -- %0s (%0d mismatches)", name, detail, errors);
        end
    endtask

    // update the reference model for one comparator
    function model(input reg prev, input real diff, input real vh);
        begin
            if (diff > vh / 2.0)       model = 1'b1;
            else if (diff < -vh / 2.0) model = 1'b0;
            else                       model = prev;
        end
    endfunction

    task apply(input real p, input real n);
        begin
            vp = p; vn = n;
            vd = p - n;
            m1 = model(m1, vd, 0.1);
            m2 = model(m2, vd, 0.4);
            #1;
            if (q1 !== m1 || q2 !== m2) begin
                if (errors == 0)
                    $sformat(detail, "vp=%.4f vn=%.4f: expected q=%b (VH=0.1) / q=%b (VH=0.4), got %b / %b",
                             p, n, m1, m2, q1, q2);
                errors = errors + 1;
            end
            #9;
        end
    endtask

    initial begin
        $timeformat(-9, 0, " ns", 0);
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut1, dut2);
        end
        m1 = 0; m2 = 0;
        #5;

        start_test;
        if (q1 !== 1'b0 || q2 !== 1'b0) begin
            errors = 1;
            $sformat(detail, "expected q=0 at start, got %b / %b", q1, q2);
        end
        end_test("output starts low");

        start_test;
        apply(0.52, 0.5); apply(0.56, 0.5); apply(0.60, 0.5);
        end_test("switches high only above +VH/2");

        start_test;
        apply(0.52, 0.5); apply(0.48, 0.5); apply(0.46, 0.5);
        end_test("holds inside the hysteresis window");

        start_test;
        apply(0.44, 0.5); apply(0.40, 0.5); apply(0.5, 0.5);
        end_test("switches low only below -VH/2");

        start_test;
        apply(0.5, 0.5); apply(0.72, 0.5); apply(0.55, 0.5); apply(0.35, 0.5); apply(0.28, 0.5);
        end_test("parameter VH is honored (VH = 0.4)");

        start_test;
        apply(1.0, 1.2); apply(1.0, 0.97); apply(1.0, 0.93); apply(1.0, 1.04); apply(1.0, 1.08);
        end_test("reacts to changes of vn");

        start_test;
        for (i = 0; i < 400; i = i + 1)
            apply(0.9 + 0.35 * $sin(i * 0.07) + 0.03 * $sin(i * 1.3), 0.9);
        end_test("noisy sine sweep (400 points)");

        $display("TB_DONE");
        $finish;
    end
endmodule
