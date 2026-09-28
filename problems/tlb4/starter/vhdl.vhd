library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tlb4 is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        vpn      : in  std_logic_vector(7 downto 0);
        hit      : out std_logic;
        ppn      : out std_logic_vector(7 downto 0);
        fill     : in  std_logic;
        fill_vpn : in  std_logic_vector(7 downto 0);
        fill_ppn : in  std_logic_vector(7 downto 0);
        flush    : in  std_logic
    );
end entity;

architecture rtl of tlb4 is
begin

    -- Your code here

end architecture;
