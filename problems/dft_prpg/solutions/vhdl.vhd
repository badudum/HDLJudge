library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prpg is
    port (clk, rst, load : in std_logic; seed : in std_logic_vector(15 downto 0); en : in std_logic;
          state : out std_logic_vector(15 downto 0); chains : out std_logic_vector(3 downto 0));
end entity;

architecture rtl of prpg is
    signal s : std_logic_vector(15 downto 0) := x"ACE1";
begin
    state <= s;
    chains <= (s(2) xor s(14)) & (s(7) xor s(12)) & (s(3) xor s(9)) & (s(0) xor s(5));
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then s <= x"ACE1";
            elsif load = '1' then s <= seed;
            elsif en = '1' then s <= s(14 downto 0) & (s(15) xor s(13) xor s(12) xor s(10));
            end if;
        end if;
    end process;
end architecture;
