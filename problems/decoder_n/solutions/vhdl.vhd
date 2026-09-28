library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_n is
    generic (
        N : positive := 3
    );
    port (
        sel : in  std_logic_vector(N-1 downto 0);
        en  : in  std_logic;
        y   : out std_logic_vector(2**N - 1 downto 0)
    );
end entity;

architecture rtl of decoder_n is
begin
    process (sel, en)
    begin
        y <= (others => '0');
        if en = '1' then
            y(to_integer(unsigned(sel))) <= '1';
        end if;
    end process;
end architecture;
