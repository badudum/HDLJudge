library ieee;
use ieee.std_logic_1164.all;

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
    signal load_use : std_logic;
begin
    load_use <= '1' when ex_mem_read = '1' and ex_rd /= "00000" and
                         ((id_uses_rs1 = '1' and ex_rd = id_rs1) or (id_uses_rs2 = '1' and ex_rd = id_rs2))
                else '0';
    stall        <= load_use and not ex_branch_taken;
    id_ex_bubble <= load_use or ex_branch_taken;
    if_id_flush  <= ex_branch_taken;
end architecture;
