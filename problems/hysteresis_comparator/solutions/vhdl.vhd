library ieee;
use ieee.std_logic_1164.all;

entity hyst_comp is
    generic (
        VH : real := 0.1
    );
    port (
        vp : in  real;
        vn : in  real;
        q  : out std_logic := '0'
    );
end entity;

architecture behavioral of hyst_comp is
begin
    process (vp, vn)
    begin
        if vp - vn > VH / 2.0 then
            q <= '1';
        elsif vp - vn < -VH / 2.0 then
            q <= '0';
        end if;
    end process;
end architecture;
