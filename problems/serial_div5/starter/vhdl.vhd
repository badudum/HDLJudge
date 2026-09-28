library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdiv5 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        valid  : in  std_logic;
        bit_in : in  std_logic;
        d5     : out std_logic
    );
end entity;

architecture rtl of sdiv5 is
begin

    -- Your code here

end architecture;
