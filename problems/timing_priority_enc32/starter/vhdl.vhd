library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity penc32 is
    port (
        req   : in  std_logic_vector(31 downto 0);
        valid : out std_logic;
        idx   : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of penc32 is
begin

    -- Your code here

end architecture;
