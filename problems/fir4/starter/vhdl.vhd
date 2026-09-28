library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir4 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        valid : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        dout  : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of fir4 is
begin

    -- Your code here

end architecture;
