library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_mult is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic;
        a       : in  std_logic_vector(7 downto 0);
        b       : in  std_logic_vector(7 downto 0);
        busy    : out std_logic;
        done    : out std_logic;
        product : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of seq_mult is
begin

    -- Your code here

end architecture;
