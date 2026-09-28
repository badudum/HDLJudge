library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is
    port (
        ex_rs1        : in  std_logic_vector(4 downto 0);
        ex_rs2        : in  std_logic_vector(4 downto 0);
        mem_rd        : in  std_logic_vector(4 downto 0);
        mem_reg_write : in  std_logic;
        wb_rd         : in  std_logic_vector(4 downto 0);
        wb_reg_write  : in  std_logic;
        fwd_a         : out std_logic_vector(1 downto 0);
        fwd_b         : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of forwarding_unit is
begin

    -- Your code here

end architecture;
