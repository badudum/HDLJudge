library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity rc_lpf is
    generic (
        TAU : real := 1.0e-6;          -- time constant [s]
        TS  : real := 10.0e-9          -- update step (clock period) [s]
    );
    port (
        clk  : in  std_logic;
        vin  : in  real;
        vout : out real := 0.0
    );
end entity;

architecture behavioral of rc_lpf is
begin

    -- Your code here

end architecture;
