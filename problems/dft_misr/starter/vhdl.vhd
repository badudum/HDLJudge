library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity misr8 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        din    : in  std_logic_vector(7 downto 0);
        golden : in  std_logic_vector(7 downto 0);
        sig    : out std_logic_vector(7 downto 0);
        pass   : out std_logic
    );
end entity;

architecture rtl of misr8 is
begin

    -- Your code here

end architecture;
