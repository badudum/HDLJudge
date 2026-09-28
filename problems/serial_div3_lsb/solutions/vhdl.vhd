library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdiv3l is
    port (clk, rst, valid, bit_in : in std_logic; d3 : out std_logic);
end entity;

architecture rtl of sdiv3l is
    signal r  : natural range 0 to 2 := 0;
    signal w2 : std_logic := '0';
begin
    d3 <= '1' when r = 0 else '0';
    process (clk)
        variable t : natural range 0 to 4;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r <= 0; w2 <= '0';
            elsif valid = '1' then
                t := r;
                if bit_in = '1' then
                    if w2 = '1' then t := t + 2; else t := t + 1; end if;
                end if;
                if t >= 3 then r <= t - 3; else r <= t; end if;
                w2 <= not w2;
            end if;
        end if;
    end process;
end architecture;
