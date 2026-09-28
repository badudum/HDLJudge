library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm8 is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        duty    : in  std_logic_vector(7 downto 0);
        pwm_out : out std_logic
    );
end entity;

architecture rtl of pwm8 is
begin

    -- Your code here

end architecture;
