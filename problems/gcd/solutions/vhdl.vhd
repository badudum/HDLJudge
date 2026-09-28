library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd16 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        start  : in  std_logic;
        a      : in  std_logic_vector(15 downto 0);
        b      : in  std_logic_vector(15 downto 0);
        busy   : out std_logic;
        done   : out std_logic;
        result : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of gcd16 is
    signal x, y   : unsigned(15 downto 0) := (others => '0');
    signal busy_r : std_logic := '0';
begin
    busy <= busy_r;
    process (clk)
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                busy_r <= '0';
                result <= (others => '0');
            elsif busy_r = '0' then
                if start = '1' then
                    x <= unsigned(a);
                    y <= unsigned(b);
                    busy_r <= '1';
                end if;
            elsif y = 0 then
                result <= std_logic_vector(x);
                done   <= '1';
                busy_r <= '0';
            elsif x < y then
                x <= y;
                y <= x;
            else
                x <= x - y;
            end if;
        end if;
    end process;
end architecture;
