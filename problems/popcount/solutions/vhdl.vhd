library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity popcount16 is
    port (
        x     : in  std_logic_vector(15 downto 0);
        count : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of popcount16 is
begin
    process (x)
        variable c : unsigned(4 downto 0);
    begin
        c := (others => '0');
        for i in x'range loop
            if x(i) = '1' then
                c := c + 1;
            end if;
        end loop;
        count <= std_logic_vector(c);
    end process;
end architecture;
