module async_fifo (
    input  wire       wclk,
    input  wire       wrst,
    input  wire       winc,
    input  wire [7:0] wdata,
    output reg        wfull,
    input  wire       rclk,
    input  wire       rrst,
    input  wire       rinc,
    output wire [7:0] rdata,
    output reg        rempty
);
    reg [7:0] mem [0:7];
    reg [3:0] wbin, wgray, rbin, rgray;
    reg [3:0] rg_w1, rg_w2;          // read pointer synchronized into wclk
    reg [3:0] wg_r1, wg_r2;          // write pointer synchronized into rclk

    // ---- write side
    wire [3:0] wbin_n  = wbin + {3'd0, winc & ~wfull};
    wire [3:0] wgray_n = wbin_n ^ (wbin_n >> 1);
    always @(posedge wclk) begin
        if (wrst) begin
            wbin <= 0; wgray <= 0; wfull <= 1'b0; rg_w1 <= 0; rg_w2 <= 0;
        end else begin
            if (winc && !wfull) mem[wbin[2:0]] <= wdata;
            wbin  <= wbin_n;
            wgray <= wgray_n;
            wfull <= (wgray_n == {~rg_w2[3:2], rg_w2[1:0]});
            rg_w1 <= rgray; rg_w2 <= rg_w1;
        end
    end

    // ---- read side
    wire [3:0] rbin_n  = rbin + {3'd0, rinc & ~rempty};
    wire [3:0] rgray_n = rbin_n ^ (rbin_n >> 1);
    always @(posedge rclk) begin
        if (rrst) begin
            rbin <= 0; rgray <= 0; rempty <= 1'b1; wg_r1 <= 0; wg_r2 <= 0;
        end else begin
            rbin   <= rbin_n;
            rgray  <= rgray_n;
            rempty <= (rgray_n == wg_r2);
            wg_r1  <= wgray; wg_r2 <= wg_r1;
        end
    end

    assign rdata = mem[rbin[2:0]];
endmodule
