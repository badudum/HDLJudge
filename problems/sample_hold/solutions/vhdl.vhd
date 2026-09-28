library ieee;
use ieee.std_logic_1164.all;

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
    signal held : real := 0.0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if track = '1' then
                held <= vin;
            else
                held <= held * DROOP;
            end if;
        end if;
    end process;
    vout <= held;
end architecture;
