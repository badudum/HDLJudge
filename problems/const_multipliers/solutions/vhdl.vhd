library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmul is
    port (x : in std_logic_vector(7 downto 0); m7, m10, m255 : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of cmul is
    signal u : unsigned(15 downto 0);
begin
    u <= resize(unsigned(x), 16);
    m7   <= std_logic_vector(shift_left(u, 3) - u);
    m10  <= std_logic_vector(shift_left(u, 3) + shift_left(u, 1));
    m255 <= std_logic_vector(shift_left(u, 8) - u);
end architecture;
