library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_inc is
    port (g : in std_logic_vector(7 downto 0); gn : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of gray_inc is
    signal t1, t2, b, n : unsigned(7 downto 0);
begin
    t1 <= unsigned(g) xor shift_right(unsigned(g), 1);
    t2 <= t1 xor shift_right(t1, 2);
    b  <= t2 xor shift_right(t2, 4);
    n  <= b + 1;
    gn <= std_logic_vector(n xor shift_right(n, 1));
end architecture;
