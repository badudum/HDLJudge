library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_unit is
    port (
        id_rs1          : in  std_logic_vector(4 downto 0);
        id_rs2          : in  std_logic_vector(4 downto 0);
        id_uses_rs1     : in  std_logic;
        id_uses_rs2     : in  std_logic;
        ex_rd           : in  std_logic_vector(4 downto 0);
        ex_mem_read     : in  std_logic;
        ex_branch_taken : in  std_logic;
        stall           : out std_logic;
        id_ex_bubble    : out std_logic;
        if_id_flush     : out std_logic
    );
end entity;

architecture rtl of hazard_unit is
begin

    -- Your code here

end architecture;
