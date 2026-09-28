library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity johnson6 is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        en   : in  std_logic;
        q    : out std_logic_vector(2 downto 0);
        tick : out std_logic
    );
end entity;

architecture rtl of johnson6 is
begin

    -- Your code here

end architecture;
