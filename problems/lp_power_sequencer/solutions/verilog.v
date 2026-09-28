module pwr_seq (
    input  wire clk,
    input  wire rst,
    input  wire sleep_req,
    input  wire wake_req,
    input  wire pwr_ack,
    output reg  clk_en,
    output reg  iso_en,
    output reg  save,
    output reg  restore,
    output reg  pwr_en,
    output reg  asleep
);
    localparam ON = 4'd0, STOP_CLK = 4'd1, ISOLATE = 4'd2, SAVE = 4'd3, PWR_OFF = 4'd4,
               OFF = 4'd5, PWR_ON = 4'd6, RESTORE = 4'd7, DEISO = 4'd8;
    reg [3:0] state;

    always @(posedge clk) begin
        if (rst) state <= ON;
        else case (state)
            ON:       if (sleep_req) state <= STOP_CLK;
            STOP_CLK: state <= ISOLATE;
            ISOLATE:  state <= SAVE;
            SAVE:     state <= PWR_OFF;
            PWR_OFF:  if (!pwr_ack) state <= OFF;
            OFF:      if (wake_req) state <= PWR_ON;
            PWR_ON:   if (pwr_ack) state <= RESTORE;
            RESTORE:  state <= DEISO;
            default:  state <= ON;
        endcase
    end

    always @(*) begin
        {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b000010;
        case (state)
            ON:       {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b100010;
            STOP_CLK: {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b000010;
            ISOLATE:  {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b010010;
            SAVE:     {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b011010;
            PWR_OFF:  {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b010000;
            OFF:      {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b010001;
            PWR_ON:   {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b010010;
            RESTORE:  {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b010110;
            default:  {clk_en, iso_en, save, restore, pwr_en, asleep} = 6'b000010;
        endcase
    end
endmodule
