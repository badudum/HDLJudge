library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dac8 is
    generic (
        VREF : real := 1.0
    );
    port (
        clk  : in  std_logic;
        code : in  std_logic_vector(7 downto 0);
        vout : out real := 0.0
    );
end entity;

architecture behavioral of dac8 is
begin

    -- Your code here

end architecture;
