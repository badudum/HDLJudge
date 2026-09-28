library ieee;
use ieee.std_logic_1164.all;

entity sd_mod1 is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        vin     : in  real;
        bit_out : out std_logic
    );
end entity;

architecture behavioral of sd_mod1 is
    signal b : std_logic := '0';
begin
    bit_out <= b;
    process (clk)
        variable integ : real := 0.0;
        variable fb    : real;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                integ := 0.0;
                b <= '0';
            else
                if b = '1' then fb := 1.0; else fb := -1.0; end if;
                integ := integ + vin - fb;
                if integ >= 0.0 then b <= '1'; else b <= '0'; end if;
            end if;
        end if;
    end process;
end architecture;
