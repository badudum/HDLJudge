library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mbist is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        start     : in  std_logic;
        mem_rdata : in  std_logic_vector(3 downto 0);
        mem_addr  : out std_logic_vector(3 downto 0);
        mem_we    : out std_logic;
        mem_wdata : out std_logic_vector(3 downto 0);
        busy      : out std_logic;
        done      : out std_logic;
        fail      : out std_logic
    );
end entity;

architecture rtl of mbist is
begin

    -- Your code here

end architecture;
