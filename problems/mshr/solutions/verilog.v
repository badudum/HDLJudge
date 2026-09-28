module mshr4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       miss_valid,
    input  wire [7:0] miss_addr,
    input  wire       resp_valid,
    input  wire [1:0] resp_id,
    output reg        mem_req,
    output reg  [1:0] mem_id,
    output reg  [7:0] mem_addr,
    output reg        merged,
    output reg  [1:0] merge_id,
    output reg        stall,
    output reg  [3:0] valid_mask
);
    reg [7:0] addr [0:3];
    reg [3:0] v;
    reg       hit, has_free;
    reg [1:0] hit_id, free_id;
    integer i;

    always @(*) begin
        v = valid_mask & ~(resp_valid ? (4'd1 << resp_id) : 4'd0);
        hit = 1'b0; hit_id = 2'd0;
        has_free = 1'b0; free_id = 2'd0;
        for (i = 3; i >= 0; i = i - 1) begin
            if (v[i] && addr[i] == miss_addr) begin hit = 1'b1; hit_id = i; end
            if (!v[i]) begin has_free = 1'b1; free_id = i; end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            valid_mask <= 4'd0;
            {mem_req, merged, stall} <= 3'b000;
        end else begin
            {mem_req, merged, stall} <= 3'b000;
            valid_mask <= v;
            if (miss_valid) begin
                if (hit) begin
                    merged <= 1'b1; merge_id <= hit_id;
                end else if (has_free) begin
                    mem_req <= 1'b1; mem_id <= free_id; mem_addr <= miss_addr;
                    addr[free_id] <= miss_addr;
                    valid_mask <= v | (4'd1 << free_id);
                end else begin
                    stall <= 1'b1;
                end
            end
        end
    end
endmodule
