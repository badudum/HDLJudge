library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ras4 is
    port (clk, rst, push, pop : in std_logic; addr : in std_logic_vector(7 downto 0);
          top : out std_logic_vector(7 downto 0); count : out std_logic_vector(2 downto 0));
end entity;

architecture rtl of ras4 is
    type mem_t is array (0 to 3) of std_logic_vector(7 downto 0);
    signal mem : mem_t;
    signal tp  : unsigned(1 downto 0) := "11";
    signal n   : natural range 0 to 4 := 0;
begin
    top <= (others => '0') when n = 0 else mem(to_integer(tp));
    count <= std_logic_vector(to_unsigned(n, 3));
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                n <= 0; tp <= "11";
            elsif push = '1' and pop = '1' and n /= 0 then
                mem(to_integer(tp)) <= addr;
            elsif push = '1' then
                mem(to_integer(tp + 1)) <= addr;
                tp <= tp + 1;
                if n /= 4 then n <= n + 1; end if;
            elsif pop = '1' and n /= 0 then
                tp <= tp - 1;
                n <= n - 1;
            end if;
        end if;
    end process;
end architecture;
