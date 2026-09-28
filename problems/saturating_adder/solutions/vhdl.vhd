library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sat_add8 is
    port (
        a   : in  std_logic_vector(7 downto 0);
        b   : in  std_logic_vector(7 downto 0);
        sum : out std_logic_vector(7 downto 0);
        ovf : out std_logic
    );
end entity;

architecture rtl of sat_add8 is
    signal s : signed(8 downto 0);
begin
    s <= resize(signed(a), 9) + resize(signed(b), 9);
    process (s)
    begin
        if s > 127 then
            sum <= x"7F"; ovf <= '1';
        elsif s < -128 then
            sum <= x"80"; ovf <= '1';
        else
            sum <= std_logic_vector(s(7 downto 0)); ovf <= '0';
        end if;
    end process;
end architecture;
