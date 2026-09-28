library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lru4 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        touch  : in  std_logic;
        way    : in  std_logic_vector(1 downto 0);
        victim : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of lru4 is
begin

    -- Your code here

end architecture;
