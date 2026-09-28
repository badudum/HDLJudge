library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity integrator is
    generic (
        K : real := 0.1
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  real;
        y   : out real := 0.0
    );
end entity;

architecture behavioral of integrator is
begin

    -- Your code here

end architecture;
