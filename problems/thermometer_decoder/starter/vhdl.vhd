library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity therm2bin is
    port (
        t     : in  std_logic_vector(14 downto 0);
        count : out std_logic_vector(3 downto 0);
        err   : out std_logic
    );
end entity;

architecture rtl of therm2bin is
begin

    -- Your code here

end architecture;
