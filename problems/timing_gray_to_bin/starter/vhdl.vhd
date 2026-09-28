library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g2b32 is
    port (
        g : in  std_logic_vector(31 downto 0);
        b : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of g2b32 is
begin

    -- Your code here

end architecture;
