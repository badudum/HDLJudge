library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity diff_amp is
    generic (
        GAIN : real := 1.0;
        VSAT : real := 1.0
    );
    port (
        clk  : in  std_logic;
        vp   : in  real;
        vn   : in  real;
        vout : out real := 0.0
    );
end entity;

architecture behavioral of diff_amp is
begin
    process (clk)
        variable raw : real;
    begin
        if rising_edge(clk) then
            raw := GAIN * (vp - vn);
            if raw > VSAT then
                vout <= VSAT;
            elsif raw < -VSAT then
                vout <= -VSAT;
            else
                vout <= raw;
            end if;
        end if;
    end process;
end architecture;
