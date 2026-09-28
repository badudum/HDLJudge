library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity therm2bin is
    port (
        t     : in  std_logic_vector(14 downto 0);
        count : out std_logic_vector(3 downto 0);
        err   : out std_logic
    );
end entity;

architecture rtl of therm2bin is
    signal t16 : unsigned(15 downto 0);
begin
    t16 <= unsigned('0' & t);
    err <= '0' when (t16 and (t16 + 1)) = 0 else '1';

    process (t)
        variable c : natural range 0 to 15;
    begin
        c := 0;
        for i in 0 to 14 loop
            if t(i) = '1' then
                c := i + 1;
            end if;
        end loop;
        count <= std_logic_vector(to_unsigned(c, 4));
    end process;
end architecture;
