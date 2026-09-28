library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdiv5 is
    port (clk, rst, valid, bit_in : in std_logic; d5 : out std_logic);
end entity;

architecture rtl of sdiv5 is
    signal r : natural range 0 to 4 := 0;
begin
    d5 <= '1' when r = 0 else '0';
    process (clk)
        variable t : natural range 0 to 9;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r <= 0;
            elsif valid = '1' then
                t := 2 * r;
                if bit_in = '1' then t := t + 1; end if;
                if t >= 5 then r <= t - 5; else r <= t; end if;
            end if;
        end if;
    end process;
end architecture;
