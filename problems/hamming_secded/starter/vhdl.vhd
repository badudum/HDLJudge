library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity secded_dec is
    port (
        code       : in  std_logic_vector(7 downto 0);
        data       : out std_logic_vector(3 downto 0);
        single_err : out std_logic;
        double_err : out std_logic
    );
end entity;

architecture rtl of secded_dec is
begin

    -- Your code here

end architecture;
