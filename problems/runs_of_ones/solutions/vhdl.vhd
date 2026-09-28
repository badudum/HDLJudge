library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity runs is
    port (x : in std_logic_vector(15 downto 0); run3 : out std_logic; alone : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of runs is
    signal u : unsigned(15 downto 0);
begin
    u <= unsigned(x);
    run3 <= '0' when (u and shift_right(u, 1) and shift_right(u, 2)) = 0 else '1';
    alone <= std_logic_vector(u and not shift_left(u, 1) and not shift_right(u, 1));
end architecture;
