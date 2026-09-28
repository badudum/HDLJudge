library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth8 is
    port (clk, rst, start : in std_logic; a, b : in std_logic_vector(7 downto 0);
          busy, done : out std_logic; p : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of booth8 is
    signal m, q : std_logic_vector(7 downto 0);
    signal acc : signed(8 downto 0);
    signal q_1, bsy : std_logic := '0';
    signal n : natural range 0 to 7 := 0;
begin
    busy <= bsy;
    process (clk)
        variable s : signed(8 downto 0);
        variable mx : signed(8 downto 0);
    begin
        if rising_edge(clk) then
            done <= '0';
            if rst = '1' then
                bsy <= '0'; p <= (others => '0');
            elsif bsy = '1' then
                mx := resize(signed(m), 9);
                if q(0) = '1' and q_1 = '0' then s := acc - mx;
                elsif q(0) = '0' and q_1 = '1' then s := acc + mx;
                else s := acc;
                end if;
                acc <= s(8) & s(8 downto 1);
                q <= s(0) & q(7 downto 1);
                q_1 <= q(0);
                if n = 7 then
                    bsy <= '0'; done <= '1';
                    p <= std_logic_vector(s(8 downto 1)) & std_logic_vector(s(0) & q(7 downto 1));
                else
                    n <= n + 1;
                end if;
            elsif start = '1' then
                bsy <= '1'; m <= a; q <= b; q_1 <= '0'; acc <= (others => '0'); n <= 0;
            end if;
        end if;
    end process;
end architecture;
