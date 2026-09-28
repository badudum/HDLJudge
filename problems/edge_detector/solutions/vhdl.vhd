library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        pulse : out std_logic
    );
end entity;

architecture rtl of edge_detect is
    signal prev : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                prev  <= '0';
                pulse <= '0';
            else
                prev  <= din;
                pulse <= din and not prev;
            end if;
        end if;
    end process;
end architecture;
