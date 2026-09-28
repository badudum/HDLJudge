library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sample_hold is
    generic (
        DROOP : real := 0.999
    );
    port (
        clk   : in  std_logic;
        track : in  std_logic;
        vin   : in  real;
        vout  : out real := 0.0
    );
end entity;

architecture behavioral of sample_hold is
begin

    -- Your code here

end architecture;
