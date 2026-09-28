library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfu4 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        hit    : in  std_logic;
        way    : in  std_logic_vector(1 downto 0);
        fill   : in  std_logic;
        victim : out std_logic_vector(1 downto 0);
        counts : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of lfu4 is
begin

    -- Your code here

end architecture;
