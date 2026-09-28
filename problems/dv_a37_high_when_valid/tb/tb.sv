`timescale 1ns/1ps
module tb;
    logic clk = 0, rst = 1, valid = 0, en = 0;
    int trace;

    chk_valid_en dut (.clk(clk), .rst(rst), .valid(valid), .en(en));

    always #5 clk = ~clk;

    task automatic drive(input string v, input string e);
        for (int i = 0; i < v.len(); i++) begin
            @(negedge clk);
            valid = (v[i] == "1");
            en    = (e[i] == "1");
        end
    endtask

    initial begin
        if ($test$plusargs("vcd")) begin
            $dumpfile("wave.vcd");
            $dumpvars(1, dut);
        end
        if (!$value$plusargs("trace=%d", trace)) trace = 0;
        @(negedge clk); @(negedge clk);
        case (trace)
            3: begin
                drive("0110110", "0000000");        // still in reset: must be ignored
                @(negedge clk); rst = 0; valid = 0; en = 0;
            end
            default: rst = 0;
        endcase
        case (trace)
            0: drive("0110111000111", "0111111000111");
            1: drive("0000111000000", "1111111011110");
            2: drive("0001000000", "0000000000");
            3: drive("0110", "0110");
            4: drive("011111111110", "011111111100");
            5: drive("00111", "00011");
            default: ;
        endcase
        drive("000", "000");
        $display("TRACE_DONE");
        $finish;
    end
endmodule
