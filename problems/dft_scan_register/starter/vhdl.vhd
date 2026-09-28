library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scan_reg is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        se  : in  std_logic;
        si  : in  std_logic;
        q   : out std_logic_vector(7 downto 0);
        so  : out std_logic
    );
end entity;

architecture rtl of scan_reg is
begin

    -- Your code here

end architecture;
