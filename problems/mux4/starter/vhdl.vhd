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

    -- Your code here

end architecture;
