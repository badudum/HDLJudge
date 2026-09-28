library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        btn   : in  std_logic;
        clean : out std_logic
    );
end entity;

architecture rtl of debounce is
begin

    -- Your code here

end architecture;
