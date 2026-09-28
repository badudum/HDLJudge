library ieee;
use ieee.std_logic_1164.all;

entity delay4 is
    port (
        clk  : in  std_logic;
        din  : in  std_logic_vector(7 downto 0);
        taps : out std_logic_vector(31 downto 0);
        dout : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of delay4 is
    -- fix: signals (updated at the end of the process), not variables
    signal s1, s2, s3, s4 : std_logic_vector(7 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            s1 <= din;
            s2 <= s1;
            s3 <= s2;
            s4 <= s3;
        end if;
    end process;
    taps <= s4 & s3 & s2 & s1;
    dout <= s4;
end architecture;
