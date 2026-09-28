library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rob8 is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        alloc_valid    : in  std_logic;
        alloc_rd       : in  std_logic_vector(4 downto 0);
        complete_valid : in  std_logic;
        complete_tag   : in  std_logic_vector(2 downto 0);
        complete_data  : in  std_logic_vector(15 downto 0);
        alloc_ok       : out std_logic;
        alloc_tag      : out std_logic_vector(2 downto 0);
        commit_valid   : out std_logic;
        commit_rd      : out std_logic_vector(4 downto 0);
        commit_data    : out std_logic_vector(15 downto 0);
        count          : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rob8 is
begin

    -- Your code here

end architecture;
