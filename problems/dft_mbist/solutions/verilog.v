module mbist (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [3:0] mem_rdata,
    output reg  [3:0] mem_addr,
    output wire       mem_we,
    output wire [3:0] mem_wdata,
    output reg        busy,
    output reg        done,
    output reg        fail
);
    // element: 0 w0 up | 1 r0,w1 up | 2 r1,w0 up | 3 r0,w1 down | 4 r1,w0 down | 5 r0
    reg [2:0] elem;
    reg       phase;         // 0 = read (or the only op), 1 = write

    wire has_read  = (elem != 3'd0);
    wire has_write = (elem != 3'd5);
    wire writing   = busy && (elem == 3'd0 || phase);
    wire [3:0] rd_expect = (elem == 3'd2 || elem == 3'd4) ? 4'hF : 4'h0;
    wire [3:0] wr_value  = (elem == 3'd1 || elem == 3'd3) ? 4'hF : 4'h0;
    wire       down      = (elem == 3'd3 || elem == 3'd4);
    wire       last_addr = down ? (mem_addr == 4'd0) : (mem_addr == 4'd15);
    wire       op_done   = (elem == 3'd0 || elem == 3'd5) ? 1'b1 : phase;   // last op at this address

    assign mem_we    = writing;
    assign mem_wdata = wr_value;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0;
            fail <= 1'b0;
        end else if (!busy) begin
            if (start) begin
                busy <= 1'b1; fail <= 1'b0;
                elem <= 3'd0; phase <= 1'b0; mem_addr <= 4'd0;
            end
        end else begin
            if (has_read && !writing && mem_rdata != rd_expect) fail <= 1'b1;
            if (!op_done) begin
                phase <= 1'b1;                                  // read done, now write
            end else begin
                phase <= 1'b0;
                if (!last_addr) begin
                    mem_addr <= down ? mem_addr - 4'd1 : mem_addr + 4'd1;
                end else if (elem == 3'd5) begin
                    busy <= 1'b0; done <= 1'b1;
                end else begin
                    elem     <= elem + 3'd1;
                    mem_addr <= (elem == 3'd2 || elem == 3'd3) ? 4'd15 : 4'd0;   // next element's start
                end
            end
        end
    end
endmodule
