module bank_conflict (
    input  wire [31:0] addr,
    input  wire [3:0]  valid,
    output wire        conflict,
    output reg  [2:0]  cycles
);
    reg [7:0] a [0:3];
    reg [2:0] cnt [0:3];      // distinct words per bank
    reg       dup;
    integer   i, j, bnk;

    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            a[i]   = addr[8*i +: 8];
            cnt[i] = 3'd0;
        end
        for (i = 0; i < 4; i = i + 1) begin
            // lane i adds a new word if no lower valid lane already asked for it
            dup = 1'b0;
            for (j = 0; j < i; j = j + 1)
                if (valid[j] && a[j] == a[i]) dup = 1'b1;
            if (valid[i] && !dup) begin
                bnk = a[i][1:0];
                cnt[bnk] = cnt[bnk] + 3'd1;
            end
        end
        cycles = 3'd0;
        for (i = 0; i < 4; i = i + 1)
            if (cnt[i] > cycles) cycles = cnt[i];
    end

    assign conflict = (cycles > 3'd1);
endmodule
