library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scan_counter is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        se    : in  std_logic;
        si    : in  std_logic;
        count : out std_logic_vector(3 downto 0);
        tc    : out std_logic;
        so    : out std_logic
    );
end entity;

architecture rtl of scan_counter is
begin

    -- Your code here

end architecture;
