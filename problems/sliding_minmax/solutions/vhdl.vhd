library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity win_minmax is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        valid : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        wmin  : out std_logic_vector(7 downto 0);
        wmax  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of win_minmax is
    type win_t is array (0 to 6) of unsigned(7 downto 0);
    signal w : win_t := (others => (others => '0'));
begin
    process (clk)
        variable mn, mx : unsigned(7 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                w <= (others => (others => '0'));
                wmin <= (others => '0'); wmax <= (others => '0');
            elsif valid = '1' then
                mn := unsigned(din); mx := unsigned(din);
                for i in 0 to 6 loop
                    if w(i) < mn then mn := w(i); end if;
                    if w(i) > mx then mx := w(i); end if;
                end loop;
                w(0) <= unsigned(din);
                for i in 1 to 6 loop
                    w(i) <= w(i - 1);
                end loop;
                wmin <= std_logic_vector(mn); wmax <= std_logic_vector(mx);
            end if;
        end if;
    end process;
end architecture;
