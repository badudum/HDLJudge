library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_cmp is
    port (
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        funct3 : in  std_logic_vector(2 downto 0);
        taken  : out std_logic
    );
end entity;

architecture rtl of branch_cmp is
begin

    -- Your code here

end architecture;
