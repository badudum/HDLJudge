library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ret_reg is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        pwr_on  : in  std_logic;
        save    : in  std_logic;
        restore : in  std_logic;
        en      : in  std_logic;
        d       : in  std_logic_vector(7 downto 0);
        q_out   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of ret_reg is
begin

    -- Your code here

end architecture;
