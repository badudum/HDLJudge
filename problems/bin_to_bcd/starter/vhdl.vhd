library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd is
    port (
        bin : in  std_logic_vector(7 downto 0);
        bcd : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of bin2bcd is
begin

    -- Your code here

end architecture;
