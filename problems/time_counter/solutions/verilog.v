module time_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick_ms,
    input  wire       load,
    input  wire [9:0] ld_ms,
    input  wire [5:0] ld_sec,
    input  wire [5:0] ld_min,
    input  wire [4:0] ld_hr,
    output reg  [9:0] ms,
    output reg  [5:0] sec,
    output reg  [5:0] min,
    output reg  [4:0] hr
);
    wire ms_wrap  = (ms == 10'd999);
    wire sec_wrap = ms_wrap && (sec == 6'd59);
    wire min_wrap = sec_wrap && (min == 6'd59);

    always @(posedge clk) begin
        if (rst) begin
            ms <= 0; sec <= 0; min <= 0; hr <= 0;
        end else if (load) begin
            ms <= ld_ms; sec <= ld_sec; min <= ld_min; hr <= ld_hr;
        end else if (tick_ms) begin
            ms <= ms_wrap ? 10'd0 : ms + 10'd1;
            if (ms_wrap)  sec <= (sec == 6'd59) ? 6'd0 : sec + 6'd1;
            if (sec_wrap) min <= (min == 6'd59) ? 6'd0 : min + 6'd1;
            if (min_wrap) hr  <= (hr == 5'd23)  ? 5'd0 : hr + 5'd1;
        end
    end
endmodule
