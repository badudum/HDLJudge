library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe3 is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        stall     : in  std_logic;
        flush     : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(15 downto 0);
        out_valid : out std_logic;
        out_data  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of pipe3 is
begin

    -- Your code here

end architecture;
