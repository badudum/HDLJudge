library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        en   : in  std_logic;
        gray : out std_logic_vector(4 downto 0);
        bin  : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of gray_counter is
begin

    -- Your code here

end architecture;
