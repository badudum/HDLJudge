`timescale 1ns/1ps
module tb;
    logic clk = 0, rst = 1, wr_en = 0, rd_en = 0;
    logic [7:0] din = 0, dout;
    logic full, empty;
    logic [2:0] count;
    logic [7:0] model[$];

    sync_fifo4 dut (.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en), .din(din),
                    .dout(dout), .full(full), .empty(empty), .count(count));
    always #5 clk = ~clk;

    // check the outputs against the model, then apply new inputs (at the falling edge)
    task automatic step(input logic r, input logic w, input logic rd, input logic [7:0] d);
        @(negedge clk);
        if (count !== model.size() || full !== (model.size() == 4) || empty !== (model.size() == 0))
            $error("t=%0t: count=%0d full=%b empty=%b, model holds %0d", $time, count, full, empty, model.size());
        if (model.size() > 0 && dout !== model[0])
            $error("t=%0t: dout=%02h, expected %02h", $time, dout, model[0]);
        rst = r; wr_en = w; rd_en = rd; din = d;
        // model update for the coming rising edge
        if (r) model.delete();
        else begin
            logic do_wr, do_rd;
            logic [7:0] front;
            do_wr = w && model.size() < 4;
            do_rd = rd && model.size() > 0;
            if (do_rd) front = model.pop_front();
            if (do_wr) model.push_back(d);
        end
    endtask

    initial begin
        step(1, 0, 0, 0);
        step(0, 0, 0, 0);
        step(0, 0, 1, 0);                                   // read while empty
        for (int i = 0; i < 6; i++) step(0, 1, 0, 8'hF0 + i);   // fill + write while full
        step(0, 1, 1, 8'h11);                               // simultaneous when full
        for (int i = 0; i < 6; i++) step(0, 0, 1, 0);           // drain + read while empty
        step(0, 1, 1, 8'h22);                               // simultaneous when empty
        step(0, 1, 1, 8'h33);
        step(0, 0, 0, 0);
        step(1, 1, 0, 8'h44);                               // reset mid-stream
        step(0, 0, 0, 0);
        for (int i = 0; i < 3000; i++)
            step($urandom_range(0, 99) == 0, $urandom_range(0, 1), $urandom_range(0, 1), $urandom);
        step(0, 0, 0, 0);
        $display("testbench finished");
        $finish;
    end
    initial begin #1000000 $error("watchdog"); $finish; end
endmodule
