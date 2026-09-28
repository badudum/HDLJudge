library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd is
    port (
        bin : in  std_logic_vector(7 downto 0);
        bcd : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of bin2bcd is
begin
    process (bin)
        variable s : unsigned(19 downto 0);
    begin
        s := x"000" & unsigned(bin);
        for i in 0 to 7 loop
            for d in 0 to 2 loop
                if s(11 + 4*d downto 8 + 4*d) >= 5 then
                    s(11 + 4*d downto 8 + 4*d) := s(11 + 4*d downto 8 + 4*d) + 3;
                end if;
            end loop;
            s := shift_left(s, 1);
        end loop;
        bcd <= std_logic_vector(s(19 downto 8));
    end process;
end architecture;
