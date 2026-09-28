library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lsb_tricks is
    port (
        x     : in  std_logic_vector(15 downto 0);
        iso   : out std_logic_vector(15 downto 0);
        clr   : out std_logic_vector(15 downto 0);
        tmask : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of lsb_tricks is
begin

    -- Your code here

end architecture;
