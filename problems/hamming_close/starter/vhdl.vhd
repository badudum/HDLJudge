library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity close16 is
    port (
        a     : in  std_logic_vector(15 downto 0);
        b     : in  std_logic_vector(15 downto 0);
        close : out std_logic
    );
end entity;

architecture rtl of close16 is
begin

    -- Your code here

end architecture;
