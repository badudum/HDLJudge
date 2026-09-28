library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
    port (
        a, b, c, d : in  std_logic_vector(7 downto 0);
        sel        : in  std_logic_vector(1 downto 0);
        y          : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of mux4 is
begin
    with sel select y <=
        a when "00",
        b when "01",
        c when "10",
        d when others;
end architecture;
