library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ras4 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        push  : in  std_logic;
        pop   : in  std_logic;
        addr  : in  std_logic_vector(7 downto 0);
        top   : out std_logic_vector(7 downto 0);
        count : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of ras4 is
begin

    -- Your code here

end architecture;
