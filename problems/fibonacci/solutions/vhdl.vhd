library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_gen is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en       : in  std_logic;
        fib      : out std_logic_vector(15 downto 0);
        overflow : out std_logic
    );
end entity;

architecture rtl of fib_gen is
    signal prev, cur : unsigned(15 downto 0);
    signal ovf       : std_logic := '0';
begin
    fib <= std_logic_vector(cur);
    overflow <= ovf;
    process (clk)
        variable n : unsigned(16 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                prev <= to_unsigned(1, 16);
                cur <= (others => '0');
                ovf <= '0';
            elsif en = '1' and ovf = '0' then
                n := ('0' & prev) + ('0' & cur);
                if n(16) = '1' then
                    ovf <= '1';
                else
                    prev <= cur;
                    cur <= n(15 downto 0);
                end if;
            end if;
        end if;
    end process;
end architecture;
