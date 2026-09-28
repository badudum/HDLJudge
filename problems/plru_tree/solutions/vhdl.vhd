library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity plru8 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        touch  : in  std_logic;
        way    : in  std_logic_vector(2 downto 0);
        victim : out std_logic_vector(2 downto 0);
        bits   : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of plru8 is
    signal b : std_logic_vector(6 downto 0) := (others => '0');
begin
    bits <= b;

    process (b)
        variable n : natural range 0 to 14;
        variable v : std_logic_vector(2 downto 0);
    begin
        n := 0;
        for lvl in 0 to 2 loop
            v(2 - lvl) := b(n);
            if b(n) = '1' then n := 2 * n + 2; else n := 2 * n + 1; end if;
        end loop;
        victim <= v;
    end process;

    process (clk)
        variable n : natural range 0 to 14;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b <= (others => '0');
            elsif touch = '1' then
                n := 0;
                for lvl in 0 to 2 loop
                    b(n) <= not way(2 - lvl);
                    if way(2 - lvl) = '1' then n := 2 * n + 2; else n := 2 * n + 1; end if;
                end loop;
            end if;
        end if;
    end process;
end architecture;
