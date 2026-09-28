library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity barrel_shifter is
    generic (
        WIDTH : positive := 8
    );
    port (
        din   : in  std_logic_vector(WIDTH-1 downto 0);
        shamt : in  std_logic_vector(integer(ceil(log2(real(WIDTH)))) - 1 downto 0);
        op    : in  std_logic_vector(1 downto 0);
        dout  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture rtl of barrel_shifter is
begin

    -- Your code here

end architecture;
