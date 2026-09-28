library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prpg is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        load   : in  std_logic;
        seed   : in  std_logic_vector(15 downto 0);
        en     : in  std_logic;
        state  : out std_logic_vector(15 downto 0);
        chains : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of prpg is
begin

    -- Your code here

end architecture;
