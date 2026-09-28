library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity slew_limiter is
    generic (
        SR : real := 1.0e7;
        TS : real := 10.0e-9
    );
    port (
        clk  : in  std_logic;
        vin  : in  real;
        vout : out real := 0.0
    );
end entity;

architecture behavioral of slew_limiter is
    constant STEP : real := SR * TS;
    signal y : real := 0.0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            y <= y + realmax(-STEP, realmin(STEP, vin - y));
        end if;
    end process;
    vout <= y;
end architecture;
