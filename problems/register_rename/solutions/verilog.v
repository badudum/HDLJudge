module rename (
    input  wire       clk,
    input  wire       rst,
    input  wire       ren_valid,
    input  wire [2:0] rs1,
    input  wire [2:0] rs2,
    input  wire [2:0] rd,
    input  wire       has_rd,
    input  wire       free_valid,
    input  wire [3:0] free_preg,
    output reg        ren_ok,
    output reg        stall,
    output reg  [3:0] ps1,
    output reg  [3:0] ps2,
    output reg  [3:0] pd,
    output reg  [3:0] old_pd
);
    reg [3:0] rat  [0:7];
    reg [3:0] fifo [0:15];
    reg [3:0] head, tail;
    reg [4:0] count;
    integer i;

    wire alloc = ren_valid && has_rd && (count != 5'd0);

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                rat[i]  <= i;
                fifo[i] <= i + 8;
            end
            head <= 4'd0; tail <= 4'd8; count <= 5'd8;
            ren_ok <= 1'b0; stall <= 1'b0;
        end else begin
            ren_ok <= ren_valid && (!has_rd || count != 5'd0);
            stall  <= ren_valid && has_rd && count == 5'd0;
            if (ren_valid) begin
                ps1 <= rat[rs1];
                ps2 <= rat[rs2];
            end
            if (alloc) begin
                pd      <= fifo[head];
                old_pd  <= rat[rd];
                rat[rd] <= fifo[head];
                head    <= head + 4'd1;
            end
            if (free_valid) begin
                fifo[tail] <= free_preg;
                tail       <= tail + 4'd1;
            end
            count <= count - alloc + free_valid;
        end
    end
endmodule
