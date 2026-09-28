library ieee;
use ieee.std_logic_1164.all;

entity gray_conv is
    port (
        bin     : in  std_logic_vector(7 downto 0);
        gray_in : in  std_logic_vector(7 downto 0);
        gray    : out std_logic_vector(7 downto 0);
        bin_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of gray_conv is
begin
    gray <= bin xor ('0' & bin(7 downto 1));

    process (gray_in)
        variable b : std_logic_vector(7 downto 0);
    begin
        b(7) := gray_in(7);
        for i in 6 downto 0 loop
            b(i) := b(i + 1) xor gray_in(i);
        end loop;
        bin_out <= b;
    end process;
end architecture;
