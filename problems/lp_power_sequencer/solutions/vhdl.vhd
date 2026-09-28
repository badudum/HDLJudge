library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwr_seq is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        sleep_req : in  std_logic;
        wake_req  : in  std_logic;
        pwr_ack   : in  std_logic;
        clk_en    : out std_logic;
        iso_en    : out std_logic;
        save      : out std_logic;
        restore   : out std_logic;
        pwr_en    : out std_logic;
        asleep    : out std_logic
    );
end entity;

architecture rtl of pwr_seq is
    type state_t is (S_ON, S_STOP_CLK, S_ISOLATE, S_SAVE, S_PWR_OFF, S_OFF, S_PWR_ON, S_RESTORE, S_DEISO);
    signal state : state_t := S_ON;
    signal o : std_logic_vector(5 downto 0);
begin
    with state select o <=
        "100010" when S_ON,
        "000010" when S_STOP_CLK,
        "010010" when S_ISOLATE,
        "011010" when S_SAVE,
        "010000" when S_PWR_OFF,
        "010001" when S_OFF,
        "010010" when S_PWR_ON,
        "010110" when S_RESTORE,
        "000010" when others;
    clk_en <= o(5); iso_en <= o(4); save <= o(3); restore <= o(2); pwr_en <= o(1); asleep <= o(0);

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S_ON;
            else
                case state is
                    when S_ON      => if sleep_req = '1' then state <= S_STOP_CLK; end if;
                    when S_STOP_CLK => state <= S_ISOLATE;
                    when S_ISOLATE => state <= S_SAVE;
                    when S_SAVE    => state <= S_PWR_OFF;
                    when S_PWR_OFF => if pwr_ack = '0' then state <= S_OFF; end if;
                    when S_OFF     => if wake_req = '1' then state <= S_PWR_ON; end if;
                    when S_PWR_ON  => if pwr_ack = '1' then state <= S_RESTORE; end if;
                    when S_RESTORE => state <= S_DEISO;
                    when S_DEISO   => state <= S_ON;
                end case;
            end if;
        end if;
    end process;
end architecture;
