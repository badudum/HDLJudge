-- Correct, but the linear scan is too deep for the timing budget.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity max8 is
    port (
        x   : in  std_logic_vector(63 downto 0);
        max : out std_logic_vector(7 downto 0);
        idx : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of max8 is
begin
    process (x)
        variable m : unsigned(7 downto 0);
        variable k : natural range 0 to 7;
    begin
        m := unsigned(x(7 downto 0));
        k := 0;
        for i in 1 to 7 loop
            if unsigned(x(8*i + 7 downto 8*i)) > m then
                m := unsigned(x(8*i + 7 downto 8*i));
                k := i;
            end if;
        end loop;
        max <= std_logic_vector(m);
        idx <= std_logic_vector(to_unsigned(k, 3));
    end process;
end architecture;
