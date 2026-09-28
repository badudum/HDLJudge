library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cg_ctrl is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        req      : in  std_logic;
        force_on : in  std_logic;
        cg_en    : out std_logic;
        ready    : out std_logic;
        saved    : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of cg_ctrl is
begin

    -- Your code here

end architecture;
