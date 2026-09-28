library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rotator8 is
    port (
        din  : in  std_logic_vector(7 downto 0);
        amt  : in  std_logic_vector(2 downto 0);
        dir  : in  std_logic;
        dout : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of rotator8 is
begin

    -- Your code here

end architecture;
