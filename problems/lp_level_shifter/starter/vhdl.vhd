library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity level_shifter is
    port (
        vin  : in  real;
        vddl : in  real;
        vddh : in  real;
        vout : out real := 0.0
    );
end entity;

architecture rtl of level_shifter is
begin

    -- Your code here

end architecture;
