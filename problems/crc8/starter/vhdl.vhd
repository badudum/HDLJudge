library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        init  : in  std_logic;
        valid : in  std_logic;
        data  : in  std_logic_vector(7 downto 0);
        crc   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of crc8 is
begin

    -- Your code here

end architecture;
