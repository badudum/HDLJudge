library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity thread_mask is
    port (
        active     : in  std_logic_vector(7 downto 0);
        cond       : in  std_logic_vector(7 downto 0);
        taken      : out std_logic_vector(7 downto 0);
        not_taken  : out std_logic_vector(7 downto 0);
        divergent  : out std_logic;
        first_lane : out std_logic_vector(2 downto 0);
        any_active : out std_logic
    );
end entity;

architecture rtl of thread_mask is
begin

    -- Your code here

end architecture;
