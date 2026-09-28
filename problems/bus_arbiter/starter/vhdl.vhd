library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_arb is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        req   : in  std_logic_vector(2 downto 0);
        lock  : in  std_logic_vector(2 downto 0);
        gnt   : out std_logic_vector(2 downto 0);
        owner : out std_logic_vector(1 downto 0);
        busy  : out std_logic
    );
end entity;

architecture rtl of bus_arb is
begin

    -- Your code here

end architecture;
