library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_ram64 is
    port (
        clk   : in  std_logic;
        en    : in  std_logic;
        we    : in  std_logic;
        addr  : in  std_logic_vector(5 downto 0);
        wdata : in  std_logic_vector(7 downto 0);
        rdata : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sp_ram64 is
begin

    -- Your code here

end architecture;
