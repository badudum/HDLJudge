library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        load       : in  std_logic;
        din        : in  std_logic_vector(7 downto 0);
        shift      : in  std_logic;
        dir        : in  std_logic;
        serial_in  : in  std_logic;
        q          : out std_logic_vector(7 downto 0);
        serial_out : out std_logic
    );
end entity;

architecture rtl of shift_reg is
begin

    -- Your code here

end architecture;
