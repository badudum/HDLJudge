library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        coin     : in  std_logic_vector(1 downto 0);
        dispense : out std_logic;
        change   : out std_logic_vector(5 downto 0);
        credit   : out std_logic_vector(5 downto 0)
    );
end entity;

architecture rtl of vending is
begin

    -- Your code here

end architecture;
