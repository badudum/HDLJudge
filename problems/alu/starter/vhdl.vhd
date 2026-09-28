library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic (
        WIDTH : positive := 8
    );
    port (
        a        : in  std_logic_vector(WIDTH-1 downto 0);
        b        : in  std_logic_vector(WIDTH-1 downto 0);
        op       : in  std_logic_vector(3 downto 0);
        y        : out std_logic_vector(WIDTH-1 downto 0);
        zero     : out std_logic;
        carry    : out std_logic;
        overflow : out std_logic;
        negative : out std_logic
    );
end entity;

architecture rtl of alu is
begin

    -- Your code here

end architecture;
