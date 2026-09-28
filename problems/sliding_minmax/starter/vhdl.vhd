library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity win_minmax is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        valid : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        wmin  : out std_logic_vector(7 downto 0);
        wmax  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of win_minmax is
begin

    -- Your code here

end architecture;
