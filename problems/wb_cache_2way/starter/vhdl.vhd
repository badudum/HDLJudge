library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_cache is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        req       : in  std_logic;
        we        : in  std_logic;
        addr      : in  std_logic_vector(5 downto 0);
        wdata     : in  std_logic_vector(7 downto 0);
        mem_rdata : in  std_logic_vector(7 downto 0);
        hit       : out std_logic;
        rdata     : out std_logic_vector(7 downto 0);
        wb_valid  : out std_logic;
        wb_addr   : out std_logic_vector(5 downto 0);
        wb_data   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of wb_cache is
begin

    -- Your code here

end architecture;
