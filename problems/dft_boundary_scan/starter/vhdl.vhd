library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bsr4 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        capture_dr : in  std_logic;
        shift_dr   : in  std_logic;
        update_dr  : in  std_logic;
        mode       : in  std_logic;
        scan_in    : in  std_logic;
        data_in    : in  std_logic_vector(3 downto 0);
        data_out   : out std_logic_vector(3 downto 0);
        scan_out   : out std_logic
    );
end entity;

architecture rtl of bsr4 is
begin

    -- Your code here

end architecture;
