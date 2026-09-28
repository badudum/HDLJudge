library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity onehot_check is
    port (
        x       : in  std_logic_vector(15 downto 0);
        onehot  : out std_logic;
        onehot0 : out std_logic
    );
end entity;

architecture rtl of onehot_check is
    signal u    : unsigned(15 downto 0);
    signal low0 : std_logic;
begin
    u <= unsigned(x);
    low0 <= '1' when (u and (u - 1)) = 0 else '0';
    onehot0 <= low0;
    onehot  <= '1' when low0 = '1' and u /= 0 else '0';
end architecture;
