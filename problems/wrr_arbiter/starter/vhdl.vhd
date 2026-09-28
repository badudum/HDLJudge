library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrr_arb is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        req : in  std_logic_vector(2 downto 0);
        gnt : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of wrr_arb is
begin

    -- Your code here

end architecture;
