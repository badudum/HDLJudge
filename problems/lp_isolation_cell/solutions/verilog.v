module iso_cells (
    input  wire       iso_en,
    input  wire [7:0] pd_data,
    input  wire       pd_valid,
    input  wire       pd_req_n,
    output wire [7:0] ao_data,
    output wire       ao_valid,
    output wire       ao_req_n
);
    assign ao_data  = pd_data & {8{~iso_en}};   // clamp 0
    assign ao_valid = pd_valid & ~iso_en;       // clamp 0
    assign ao_req_n = pd_req_n | iso_en;        // clamp 1 (active-low)
endmodule
