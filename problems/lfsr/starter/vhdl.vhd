library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr8 is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        load : in  std_logic;
        seed : in  std_logic_vector(7 downto 0);
        en   : in  std_logic;
        q    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of lfsr8 is
begin

    -- Your code here

end architecture;
