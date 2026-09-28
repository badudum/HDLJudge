library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_conv is
    port (
        bin     : in  std_logic_vector(7 downto 0);
        gray_in : in  std_logic_vector(7 downto 0);
        gray    : out std_logic_vector(7 downto 0);
        bin_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of gray_conv is
begin

    -- Your code here

end architecture;
