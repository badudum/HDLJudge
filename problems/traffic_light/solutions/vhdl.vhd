library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        car  : in  std_logic;
        main : out std_logic_vector(1 downto 0);
        side : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of traffic_light is
    type state_t is (MAIN_GREEN, MAIN_YELLOW, SIDE_GREEN, SIDE_YELLOW);
    constant RED    : std_logic_vector(1 downto 0) := "00";
    constant YELLOW : std_logic_vector(1 downto 0) := "01";
    constant GREEN  : std_logic_vector(1 downto 0) := "10";
    signal state : state_t := MAIN_GREEN;
    signal timer : natural range 0 to 7 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= MAIN_GREEN;
                timer <= 0;
            else
                case state is
                    when MAIN_GREEN =>
                        if timer >= 5 and car = '1' then
                            state <= MAIN_YELLOW; timer <= 0;
                        elsif timer /= 7 then
                            timer <= timer + 1;
                        end if;
                    when MAIN_YELLOW =>
                        if timer = 1 then state <= SIDE_GREEN; timer <= 0; else timer <= timer + 1; end if;
                    when SIDE_GREEN =>
                        if timer = 3 then state <= SIDE_YELLOW; timer <= 0; else timer <= timer + 1; end if;
                    when SIDE_YELLOW =>
                        if timer = 1 then state <= MAIN_GREEN; timer <= 0; else timer <= timer + 1; end if;
                end case;
            end if;
        end if;
    end process;

    with state select main <=
        GREEN  when MAIN_GREEN,
        YELLOW when MAIN_YELLOW,
        RED    when others;
    with state select side <=
        GREEN  when SIDE_GREEN,
        YELLOW when SIDE_YELLOW,
        RED    when others;
end architecture;
