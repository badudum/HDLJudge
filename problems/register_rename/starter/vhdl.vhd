library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rename is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        ren_valid  : in  std_logic;
        rs1        : in  std_logic_vector(2 downto 0);
        rs2        : in  std_logic_vector(2 downto 0);
        rd         : in  std_logic_vector(2 downto 0);
        has_rd     : in  std_logic;
        free_valid : in  std_logic;
        free_preg  : in  std_logic_vector(3 downto 0);
        ren_ok     : out std_logic;
        stall      : out std_logic;
        ps1        : out std_logic_vector(3 downto 0);
        ps2        : out std_logic_vector(3 downto 0);
        pd         : out std_logic_vector(3 downto 0);
        old_pd     : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of rename is
begin

    -- Your code here

end architecture;
