library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        pulse : out std_logic
    );
end entity;

architecture rtl of edge_detect is
begin

    -- Your code here

end architecture;
