library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_rf is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        we    : in  std_logic;
        waddr : in  std_logic_vector(1 downto 0);
        wbe   : in  std_logic_vector(3 downto 0);
        wdata : in  std_logic_vector(31 downto 0);
        raddr : in  std_logic_vector(1 downto 0);
        rdata : out std_logic_vector(31 downto 0);
        cg_en : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of byte_rf is
begin

    -- Your code here

end architecture;
