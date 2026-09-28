library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        en   : in  std_logic;
        gray : out std_logic_vector(4 downto 0);
        bin  : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of gray_counter is
    signal b : unsigned(4 downto 0) := (others => '0');
begin
    bin <= std_logic_vector(b);
    process (clk)
        variable n : unsigned(4 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                b <= (others => '0');
                gray <= (others => '0');
            elsif en = '1' then
                n := b + 1;
                b <= n;
                gray <= std_logic_vector(n xor shift_right(n, 1));
            end if;
        end if;
    end process;
end architecture;
