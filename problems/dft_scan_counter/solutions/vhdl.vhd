library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scan_counter is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        se    : in  std_logic;
        si    : in  std_logic;
        count : out std_logic_vector(3 downto 0);
        tc    : out std_logic;
        so    : out std_logic
    );
end entity;

architecture rtl of scan_counter is
    signal c : unsigned(3 downto 0) := (others => '0');
begin
    count <= std_logic_vector(c);
    tc <= '1' when c = 15 else '0';
    so <= c(3);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                c <= (others => '0');
            elsif se = '1' then
                c <= c(2 downto 0) & si;
            elsif en = '1' then
                c <= c + 1;
            end if;
        end if;
    end process;
end architecture;
