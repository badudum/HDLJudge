library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmul is
    port (
        x    : in  std_logic_vector(7 downto 0);
        m7   : out std_logic_vector(15 downto 0);
        m10  : out std_logic_vector(15 downto 0);
        m255 : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of cmul is
begin

    -- Your code here

end architecture;
