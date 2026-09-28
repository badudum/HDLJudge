library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_inc is
    port (
        g  : in  std_logic_vector(7 downto 0);
        gn : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of gray_inc is
begin

    -- Your code here

end architecture;
