library ieee;
use ieee.std_logic_1164.all;

entity div_by_3 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        din : in  std_logic;
        div : out std_logic
    );
end entity;

architecture rtl of div_by_3 is
    type rem_t is (R0, R1, R2);
    signal r : rem_t := R0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r <= R0;
            else
                case r is
                    when R0 => if din = '1' then r <= R1; else r <= R0; end if;
                    when R1 => if din = '1' then r <= R0; else r <= R2; end if;
                    when R2 => if din = '1' then r <= R2; else r <= R1; end if;
                end case;
            end if;
        end if;
    end process;
    div <= '1' when r = R0 else '0';
end architecture;
