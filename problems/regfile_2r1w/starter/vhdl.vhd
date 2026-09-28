library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port (
        clk    : in  std_logic;
        we     : in  std_logic;
        waddr  : in  std_logic_vector(4 downto 0);
        wdata  : in  std_logic_vector(31 downto 0);
        raddr1 : in  std_logic_vector(4 downto 0);
        raddr2 : in  std_logic_vector(4 downto 0);
        rdata1 : out std_logic_vector(31 downto 0);
        rdata2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of regfile is
begin

    -- Your code here

end architecture;
