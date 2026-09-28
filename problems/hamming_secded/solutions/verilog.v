module secded_dec (
    input  wire [7:0] code,
    output reg  [3:0] data,
    output wire       single_err,
    output wire       double_err
);
    wire s1 = code[0] ^ code[2] ^ code[4] ^ code[6];
    wire s2 = code[1] ^ code[2] ^ code[5] ^ code[6];
    wire s4 = code[3] ^ code[4] ^ code[5] ^ code[6];
    wire [2:0] syn = {s4, s2, s1};
    wire parity = ^code;

    assign single_err = parity;
    assign double_err = !parity && (syn != 3'd0);

    always @(*) begin
        data = {code[6], code[5], code[4], code[2]};
        if (parity) begin
            case (syn)
                3'd3: data[0] = ~data[0];
                3'd5: data[1] = ~data[1];
                3'd6: data[2] = ~data[2];
                3'd7: data[3] = ~data[3];
                default: ;
            endcase
        end
    end
endmodule
