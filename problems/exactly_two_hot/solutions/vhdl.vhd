library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_hot is
    port (x : in std_logic_vector(15 downto 0); two : out std_logic);
end entity;

architecture rtl of two_hot is
    signal y : unsigned(15 downto 0);
begin
    y <= unsigned(x) and (unsigned(x) - 1);
    two <= '1' when y /= 0 and (y and (y - 1)) = 0 else '0';
end architecture;
