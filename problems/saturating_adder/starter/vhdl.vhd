library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sat_add8 is
    port (
        a   : in  std_logic_vector(7 downto 0);
        b   : in  std_logic_vector(7 downto 0);
        sum : out std_logic_vector(7 downto 0);
        ovf : out std_logic
    );
end entity;

architecture rtl of sat_add8 is
begin

    -- Your code here

end architecture;
