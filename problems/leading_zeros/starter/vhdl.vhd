library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clz16 is
    port (
        x : in  std_logic_vector(15 downto 0);
        n : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of clz16 is
begin

    -- Your code here

end architecture;
