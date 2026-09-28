library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv32i_decode is
    port (
        instr     : in  std_logic_vector(31 downto 0);
        fmt       : out std_logic_vector(2 downto 0);
        imm       : out std_logic_vector(31 downto 0);
        reg_write : out std_logic;
        mem_read  : out std_logic;
        mem_write : out std_logic;
        branch    : out std_logic;
        jump      : out std_logic
    );
end entity;

architecture rtl of rv32i_decode is
begin

    -- Your code here

end architecture;
