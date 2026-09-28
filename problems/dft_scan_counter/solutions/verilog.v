module scan_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire       se,
    input  wire       si,
    output reg  [3:0] count,
    output wire       tc,
    output wire       so
);
    wire [3:0] func_next = en ? count + 4'd1 : count;

    always @(posedge clk) begin
        if (rst) count <= 4'd0;
        else     count <= se ? {count[2:0], si} : func_next;   // scan mux in front of the flops
    end

    assign tc = (count == 4'd15);
    assign so = count[3];
endmodule
