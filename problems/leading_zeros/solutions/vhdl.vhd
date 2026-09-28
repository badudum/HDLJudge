library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clz16 is
    port (
        x : in  std_logic_vector(15 downto 0);
        n : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of clz16 is
begin
    process (x)
        variable r : natural range 0 to 16;
    begin
        r := 16;
        for i in 0 to 15 loop
            if x(i) = '1' then
                r := 15 - i;
            end if;
        end loop;
        n <= std_logic_vector(to_unsigned(r, 5));
    end process;
end architecture;
