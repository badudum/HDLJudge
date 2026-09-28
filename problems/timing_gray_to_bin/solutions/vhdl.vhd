library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g2b32 is
    port (g : in std_logic_vector(31 downto 0); b : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of g2b32 is
    signal t0, t1, t2, t3, t4 : unsigned(31 downto 0);
begin
    t0 <= unsigned(g);
    t1 <= t0 xor shift_right(t0, 1);
    t2 <= t1 xor shift_right(t1, 2);
    t3 <= t2 xor shift_right(t2, 4);
    t4 <= t3 xor shift_right(t3, 8);
    b <= std_logic_vector(t4 xor shift_right(t4, 16));
end architecture;
