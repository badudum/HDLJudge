module rob8 (
    input  wire        clk,
    input  wire        rst,
    input  wire        alloc_valid,
    input  wire [4:0]  alloc_rd,
    input  wire        complete_valid,
    input  wire [2:0]  complete_tag,
    input  wire [15:0] complete_data,
    output reg         alloc_ok,
    output reg  [2:0]  alloc_tag,
    output reg         commit_valid,
    output reg  [4:0]  commit_rd,
    output reg  [15:0] commit_data,
    output reg  [3:0]  count
);
    reg [7:0]  valid, done;
    reg [4:0]  rd   [0:7];
    reg [15:0] data [0:7];
    reg [2:0]  head, tail;

    wire commit = valid[head] && done[head];
    wire alloc  = alloc_valid && (count != 4'd8);

    always @(posedge clk) begin
        if (rst) begin
            valid <= 8'd0; done <= 8'd0;
            head <= 3'd0; tail <= 3'd0; count <= 4'd0;
            alloc_ok <= 1'b0; commit_valid <= 1'b0;
        end else begin
            commit_valid <= commit;
            if (commit) begin
                commit_rd   <= rd[head];
                commit_data <= data[head];
            end
            if (complete_valid) begin
                done[complete_tag] <= 1'b1;
                data[complete_tag] <= complete_data;
            end
            if (commit) begin
                valid[head] <= 1'b0;
                head        <= head + 3'd1;
            end
            alloc_ok <= alloc;
            if (alloc) begin
                valid[tail] <= 1'b1;
                done[tail]  <= 1'b0;       // written after the commit clear: same entry can't be both
                rd[tail]    <= alloc_rd;
                alloc_tag   <= tail;
                tail        <= tail + 3'd1;
            end
            count <= count - commit + alloc;
        end
    end
endmodule
