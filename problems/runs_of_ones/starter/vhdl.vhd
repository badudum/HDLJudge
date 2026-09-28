library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity runs is
    port (
        x     : in  std_logic_vector(15 downto 0);
        run3  : out std_logic;
        alone : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of runs is
begin

    -- Your code here

end architecture;
