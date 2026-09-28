library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity rc_lpf is
    generic (
        TAU : real := 1.0e-6;
        TS  : real := 10.0e-9
    );
    port (
        clk  : in  std_logic;
        vin  : in  real;
        vout : out real := 0.0
    );
end entity;

architecture behavioral of rc_lpf is
    constant ALPHA : real := 1.0 - exp(-TS / TAU);
    signal state   : real := 0.0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            state <= state + (vin - state) * ALPHA;
        end if;
    end process;
    vout <= state;
end architecture;
