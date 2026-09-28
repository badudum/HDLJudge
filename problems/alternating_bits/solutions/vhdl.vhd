library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alt16 is
    port (x : in std_logic_vector(15 downto 0); alt : out std_logic);
end entity;

architecture rtl of alt16 is
    signal y : std_logic_vector(15 downto 0);
begin
    y <= x xor ('0' & x(15 downto 1));
    alt <= '1' when y(14 downto 0) = "111111111111111" else '0';
end architecture;
