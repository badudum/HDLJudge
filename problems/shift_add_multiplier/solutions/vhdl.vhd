library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity smul8 is
    port (
        a : in  std_logic_vector(7 downto 0);
        b : in  std_logic_vector(7 downto 0);
        p : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of smul8 is
begin
    process (a, b)
        variable ax, acc : signed(15 downto 0);
    begin
        ax := resize(signed(a), 16);
        acc := (others => '0');
        for i in 0 to 6 loop
            if b(i) = '1' then acc := acc + shift_left(ax, i); end if;
        end loop;
        if b(7) = '1' then acc := acc - shift_left(ax, 7); end if;
        p <= std_logic_vector(acc);
    end process;
end architecture;
