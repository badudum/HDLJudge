library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity way_pred is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        req       : in  std_logic;
        addr      : in  std_logic_vector(5 downto 0);
        pred      : out std_logic;
        fast_hit  : out std_logic;
        slow_hit  : out std_logic;
        miss      : out std_logic;
        tag_reads : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of way_pred is
begin

    -- Your code here

end architecture;
