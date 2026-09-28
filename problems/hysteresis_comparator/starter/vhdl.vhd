library ieee;
use ieee.std_logic_1164.all;

entity hyst_comp is
    generic (
        VH : real := 0.1                 -- total hysteresis window in volts
    );
    port (
        vp : in  real;
        vn : in  real;
        q  : out std_logic := '0'
    );
end entity;

architecture behavioral of hyst_comp is
begin

    -- Your code here

end architecture;
