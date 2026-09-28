library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity johnson6 is
    port (clk, rst, en : in std_logic; q : out std_logic_vector(2 downto 0); tick : out std_logic);
end entity;

architecture rtl of johnson6 is
    signal r : std_logic_vector(2 downto 0) := "000";
begin
    q <= r;
    tick <= r(2) and not r(1);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then r <= "000";
            elsif en = '1' then r <= r(1 downto 0) & (not r(2));
            end if;
        end if;
    end process;
end architecture;
