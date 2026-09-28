`timescale 1ns/1ps
module tb;
    logic [7:0] a, b, y;
    logic [2:0] op;
    logic carry, zero, neg;

    alu8 dut (.a(a), .b(b), .op(op), .y(y), .carry(carry), .zero(zero), .neg(neg));

    task automatic check(input logic [7:0] ta, input logic [7:0] tb_, input logic [2:0] top);
        logic [8:0] w;
        logic [7:0] ey;
        logic ec;
        int s;
        a = ta; b = tb_; op = top;
        #1;
        s = tb_[2:0];
        ec = 0;
        case (top)
            0: begin w = ta + tb_; ey = w[7:0]; ec = w[8]; end
            1: begin ey = ta - tb_; ec = ta < tb_; end
            2: ey = ta & tb_;
            3: ey = ta | tb_;
            4: ey = ta ^ tb_;
            5: begin ey = ta << s; ec = s ? ta[8 - s] : 0; end
            6: begin ey = ta >> s; ec = s ? ta[s - 1] : 0; end
            default: ey = ($signed(ta) < $signed(tb_)) ? 8'd1 : 8'd0;
        endcase
        if (y !== ey || carry !== ec || zero !== (ey == 0) || neg !== ey[7])
            $error("op=%0d a=%02h b=%02h: got y=%02h c=%b z=%b n=%b, expected y=%02h c=%b z=%b n=%b",
                   top, ta, tb_, y, carry, zero, neg, ey, ec, ey == 0, ey[7]);
    endtask

    initial begin
        logic [7:0] corners [0:7];
        corners[0] = 8'h00; corners[1] = 8'h01; corners[2] = 8'h7F; corners[3] = 8'h80;
        corners[4] = 8'hFF; corners[5] = 8'h55; corners[6] = 8'hAA; corners[7] = 8'hFE;
        for (int o = 0; o < 8; o++)
            for (int i = 0; i < 8; i++)
                for (int j = 0; j < 8; j++)
                    check(corners[i], corners[j], o);
        for (int o = 5; o < 7; o++)                 // every shift amount
            for (int s = 0; s < 8; s++)
                for (int i = 0; i < 8; i++)
                    check(corners[i], s, o);
        repeat (5000) check($urandom, $urandom, $urandom);
        $display("testbench finished");
        $finish;
    end
endmodule
