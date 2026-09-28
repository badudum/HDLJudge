library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
    port (
        alu_op   : in  std_logic_vector(1 downto 0);
        funct3   : in  std_logic_vector(2 downto 0);
        funct7_5 : in  std_logic;
        alu_ctrl : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of alu_control is
begin

    -- Your code here

end architecture;
