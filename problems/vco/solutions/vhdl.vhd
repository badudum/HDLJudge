library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity vco is
    generic (
        F0   : real := 100.0e6;
        KVCO : real := 50.0e6
    );
    port (
        vctrl   : in  real;
        clk_out : out std_logic := '0'
    );
end entity;

architecture behavioral of vco is
    signal q : std_logic := '0';
begin
    clk_out <= q;
    process
        variable f : real;
    begin
        f := realmax(1.0e6, realmin(1.0e9, F0 + KVCO * vctrl));
        wait for (0.5 / f) * 1 sec;
        q <= not q;
    end process;
end architecture;
