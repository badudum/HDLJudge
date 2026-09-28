library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        count : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of counter is
begin

    -- Your code here

end architecture;
