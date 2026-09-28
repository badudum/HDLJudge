library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity next_pow2 is
    port (
        x : in  std_logic_vector(15 downto 0);
        y : out std_logic_vector(16 downto 0)
    );
end entity;

architecture rtl of next_pow2 is
    signal v0, v1, v2, v3, v4 : unsigned(15 downto 0);
begin
    v0 <= unsigned(x) - 1;
    v1 <= v0 or shift_right(v0, 1);
    v2 <= v1 or shift_right(v1, 2);
    v3 <= v2 or shift_right(v2, 4);
    v4 <= v3 or shift_right(v3, 8);
    y <= std_logic_vector(to_unsigned(1, 17)) when unsigned(x) = 0 else
         std_logic_vector(resize(v4, 17) + 1);
end architecture;
