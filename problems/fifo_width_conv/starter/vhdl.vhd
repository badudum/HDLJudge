library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity width_conv is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(7 downto 0);
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_data  : out std_logic_vector(31 downto 0);
        out_ready : in  std_logic
    );
end entity;

architecture rtl of width_conv is
begin

    -- Your code here

end architecture;
