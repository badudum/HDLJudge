library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity vco is
    generic (
        F0 : real := 100.0e6;
        KVCO : real := 50.0e6
    );
    port (
        vctrl   : in  real;
        clk_out : out std_logic
    );
end entity;

architecture behavioral of vco is
begin

    -- Your code here

end architecture;
