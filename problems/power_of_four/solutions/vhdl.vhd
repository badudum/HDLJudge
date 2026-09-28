library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pow4 is
    port (x : in std_logic_vector(15 downto 0); p4 : out std_logic);
end entity;

architecture rtl of pow4 is
    signal u : unsigned(15 downto 0);
begin
    u <= unsigned(x);
    p4 <= '1' when u /= 0 and (u and (u - 1)) = 0 and (u and x"5555") /= 0 else '0';
end architecture;
