library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simd_alu is
    port (
        a    : in  std_logic_vector(31 downto 0);
        b    : in  std_logic_vector(31 downto 0);
        mode : in  std_logic;
        op   : in  std_logic_vector(1 downto 0);
        y    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of simd_alu is
begin

    -- Your code here

end architecture;
