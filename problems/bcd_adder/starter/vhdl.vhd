library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_add is
    port (
        a    : in  std_logic_vector(3 downto 0);
        b    : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end entity;

architecture rtl of bcd_add is
begin

    -- Your code here

end architecture;
