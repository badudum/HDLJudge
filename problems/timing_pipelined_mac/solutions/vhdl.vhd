library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac2 is
    port (
        clk : in  std_logic;
        a   : in  std_logic_vector(7 downto 0);
        b   : in  std_logic_vector(7 downto 0);
        c   : in  std_logic_vector(7 downto 0);
        d   : in  std_logic_vector(7 downto 0);
        y   : out std_logic_vector(16 downto 0)
    );
end entity;

architecture rtl of mac2 is
    signal p1, p2 : unsigned(15 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            p1 <= unsigned(a) * unsigned(b);
            p2 <= unsigned(c) * unsigned(d);
            y  <= std_logic_vector(resize(p1, 17) + resize(p2, 17));
        end if;
    end process;
end architecture;
