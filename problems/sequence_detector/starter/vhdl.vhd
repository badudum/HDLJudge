library ieee;
use ieee.std_logic_1164.all;

entity seq_detect is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        din      : in  std_logic;
        detected : out std_logic
    );
end entity;

architecture rtl of seq_detect is
begin

    -- Your code here

end architecture;
