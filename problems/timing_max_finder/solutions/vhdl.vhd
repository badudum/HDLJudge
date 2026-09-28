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
    type val_t is array (0 to 7) of unsigned(7 downto 0);
    type idx_t is array (0 to 7) of unsigned(2 downto 0);
begin
    process (x)
        variable v    : val_t;
        variable k    : idx_t;
        variable step : natural;
    begin
        for i in 0 to 7 loop
            v(i) := unsigned(x(8*i + 7 downto 8*i));
            k(i) := to_unsigned(i, 3);
        end loop;
        for lvl in 0 to 2 loop
            step := 2 ** lvl;
            for i in 0 to 7 loop
                if i mod (2 * step) = 0 then
                    if v(i + step) > v(i) then
                        v(i) := v(i + step);
                        k(i) := k(i + step);
                    end if;
                end if;
            end loop;
        end loop;
        max <= std_logic_vector(v(0));
        idx <= std_logic_vector(k(0));
    end process;
end architecture;
