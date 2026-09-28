library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_gen is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en       : in  std_logic;
        fib      : out std_logic_vector(15 downto 0);
        overflow : out std_logic
    );
end entity;

architecture rtl of fib_gen is
begin

    -- Your code here

end architecture;
