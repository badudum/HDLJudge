library ieee;
use ieee.std_logic_1164.all;

entity integrator is
    generic (K : real := 0.1);
    port (clk, rst : in std_logic; x : in real; y : out real := 0.0);
end entity;

architecture model of integrator is
begin
    process (clk)
        variable acc : real := 0.0;
    begin
        if rising_edge(clk) then
            if rst = '1' then acc := 0.0;
            else
                acc := acc + K * x;
                if acc > 1.0 then acc := 1.0; elsif acc < -1.0 then acc := -1.0; end if;
            end if;
            y <= acc;
        end if;
    end process;
end architecture;
