library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity warp_sched is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        ready       : in  std_logic_vector(3 downto 0);
        issue_valid : out std_logic;
        issue_warp  : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of warp_sched is
begin

    -- Your code here

end architecture;
