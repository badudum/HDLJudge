library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity manchester_tx is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        load : in  std_logic;
        data : in  std_logic_vector(7 downto 0);
        tx   : out std_logic;
        busy : out std_logic
    );
end entity;

architecture rtl of manchester_tx is
begin

    -- Your code here

end architecture;
