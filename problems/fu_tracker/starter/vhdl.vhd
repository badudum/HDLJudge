library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fu_tracker is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        issue    : in  std_logic;
        fu       : in  std_logic_vector(1 downto 0);
        latency  : in  std_logic_vector(2 downto 0);
        busy     : out std_logic_vector(3 downto 0);
        accepted : out std_logic
    );
end entity;

architecture rtl of fu_tracker is
begin

    -- Your code here

end architecture;
