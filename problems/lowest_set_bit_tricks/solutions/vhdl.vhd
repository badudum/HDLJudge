library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lsb_tricks is
    port (x : in std_logic_vector(15 downto 0); iso, clr, tmask : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of lsb_tricks is
    signal u, m1 : unsigned(15 downto 0);
begin
    u  <= unsigned(x);
    m1 <= u - 1;
    iso   <= std_logic_vector(u and (not u + 1));
    clr   <= std_logic_vector(u and m1);
    tmask <= std_logic_vector((not u) and m1);
end architecture;
