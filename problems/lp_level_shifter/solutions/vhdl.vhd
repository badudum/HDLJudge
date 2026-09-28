library ieee;
use ieee.std_logic_1164.all;

entity level_shifter is
    port (
        vin  : in  real;
        vddl : in  real;
        vddh : in  real;
        vout : out real := 0.0
    );
end entity;

architecture model of level_shifter is
begin
    process (vin, vddl, vddh)
        variable state : boolean := false;
    begin
        if vddl < 0.3 then state := false;
        elsif vin > 0.6 * vddl then state := true;
        elsif vin < 0.4 * vddl then state := false;
        end if;
        if state and vddl >= 0.3 then vout <= vddh; else vout <= 0.0; end if;
    end process;
end architecture;
