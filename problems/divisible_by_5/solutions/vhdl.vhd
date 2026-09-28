library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div5 is
    port (x : in std_logic_vector(15 downto 0); d5 : out std_logic);
end entity;

architecture rtl of div5 is
    signal s1 : unsigned(5 downto 0);
    signal s2 : unsigned(4 downto 0);
begin
    s1 <= resize(unsigned(x(3 downto 0)), 6) + unsigned(x(7 downto 4)) + unsigned(x(11 downto 8)) + unsigned(x(15 downto 12));
    s2 <= resize(s1(3 downto 0), 5) + s1(5 downto 4);
    d5 <= '1' when s2 = 0 or s2 = 5 or s2 = 10 or s2 = 15 else '0';
end architecture;
