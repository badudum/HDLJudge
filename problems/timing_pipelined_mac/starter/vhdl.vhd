-- Correct (latency 2) but the second stage is too deep: multiply AND add in one cycle.
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
    signal ra, rb, rc, rd : unsigned(7 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            ra <= unsigned(a); rb <= unsigned(b); rc <= unsigned(c); rd <= unsigned(d);
            y  <= std_logic_vector(resize(ra * rb, 17) + resize(rc * rd, 17));
        end if;
    end process;
end architecture;
