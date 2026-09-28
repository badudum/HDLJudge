library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram32 is
    port (
        clk    : in  std_logic;
        we_a   : in  std_logic;
        addr_a : in  std_logic_vector(4 downto 0);
        din_a  : in  std_logic_vector(7 downto 0);
        dout_a : out std_logic_vector(7 downto 0);
        we_b   : in  std_logic;
        addr_b : in  std_logic_vector(4 downto 0);
        din_b  : in  std_logic_vector(7 downto 0);
        dout_b : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of dp_ram32 is
begin

    -- Your code here

end architecture;
