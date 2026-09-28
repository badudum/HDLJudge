library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dm_cache is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        rd        : in  std_logic;
        wr        : in  std_logic;
        fill      : in  std_logic;
        inv       : in  std_logic;
        addr      : in  std_logic_vector(7 downto 0);
        wdata     : in  std_logic_vector(7 downto 0);
        fill_data : in  std_logic_vector(7 downto 0);
        hit       : out std_logic;
        rdata     : out std_logic_vector(7 downto 0);
        hits      : out std_logic_vector(7 downto 0);
        misses    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of dm_cache is
begin

    -- Your code here

end architecture;
