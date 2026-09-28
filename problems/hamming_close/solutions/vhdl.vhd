library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity close16 is
    port (a, b : in std_logic_vector(15 downto 0); close : out std_logic);
end entity;

architecture rtl of close16 is
    signal d : unsigned(15 downto 0);
begin
    d <= unsigned(a xor b);
    close <= '1' when (d and (d - 1)) = 0 else '0';
end architecture;
