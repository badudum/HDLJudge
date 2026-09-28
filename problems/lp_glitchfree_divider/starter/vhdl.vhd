library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gf_div is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        div     : in  std_logic_vector(1 downto 0);
        clk_out : out std_logic
    );
end entity;

architecture rtl of gf_div is
begin

    -- Your code here

end architecture;
