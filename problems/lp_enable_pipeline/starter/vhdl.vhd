library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gated_pipe is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(7 downto 0);
        out_valid : out std_logic;
        out_data  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of gated_pipe is
begin

    -- Your code here

end architecture;
