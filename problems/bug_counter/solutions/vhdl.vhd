library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        digit : out std_logic_vector(3 downto 0);
        carry : out std_logic
    );
end entity;

architecture rtl of bcd_counter is
    signal d : unsigned(3 downto 0) := (others => '0');
begin
    digit <= std_logic_vector(d);
    carry <= '1' when d = 9 and en = '1' else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                d <= (others => '0');
            elsif en = '1' then
                if d = 9 then
                    d <= (others => '0');
                else
                    d <= d + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
