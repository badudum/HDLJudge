library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity adc8 is
    generic (
        VREF : real := 1.0
    );
    port (
        clk  : in  std_logic;
        vin  : in  real;
        code : out std_logic_vector(7 downto 0) := (others => '0')
    );
end entity;

architecture behavioral of adc8 is
begin

    -- Your code here

end architecture;
