library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_div is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        dividend  : in  std_logic_vector(15 downto 0);
        divisor   : in  std_logic_vector(15 downto 0);
        busy      : out std_logic;
        done      : out std_logic;
        quotient  : out std_logic_vector(15 downto 0);
        remainder : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of seq_div is
begin

    -- Your code here

end architecture;
