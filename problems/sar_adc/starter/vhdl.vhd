library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sar_ctrl is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        start  : in  std_logic;
        cmp    : in  std_logic;
        dac    : out std_logic_vector(7 downto 0);
        done   : out std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sar_ctrl is
begin

    -- Your code here

end architecture;
