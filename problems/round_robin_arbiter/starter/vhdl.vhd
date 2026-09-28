library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rr_arbiter4 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        req   : in  std_logic_vector(3 downto 0);
        grant : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rr_arbiter4 is
begin

    -- Your code here

end architecture;
