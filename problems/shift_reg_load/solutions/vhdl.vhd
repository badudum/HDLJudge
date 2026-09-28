library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        load       : in  std_logic;
        din        : in  std_logic_vector(7 downto 0);
        shift      : in  std_logic;
        dir        : in  std_logic;
        serial_in  : in  std_logic;
        q          : out std_logic_vector(7 downto 0);
        serial_out : out std_logic
    );
end entity;

architecture rtl of shift_reg is
    signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
    q <= r;
    serial_out <= r(0) when dir = '1' else r(7);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r <= (others => '0');
            elsif load = '1' then
                r <= din;
            elsif shift = '1' then
                if dir = '1' then r <= serial_in & r(7 downto 1);
                else r <= r(6 downto 0) & serial_in;
                end if;
            end if;
        end if;
    end process;
end architecture;
