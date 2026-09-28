library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_alu is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        stall     : in  std_logic;
        valid_in  : in  std_logic;
        op        : in  std_logic_vector(1 downto 0);
        a         : in  std_logic_vector(15 downto 0);
        b         : in  std_logic_vector(15 downto 0);
        valid_out : out std_logic;
        y         : out std_logic_vector(15 downto 0);
        zero      : out std_logic
    );
end entity;

architecture rtl of pipe_alu is
begin

    -- Your code here

end architecture;
