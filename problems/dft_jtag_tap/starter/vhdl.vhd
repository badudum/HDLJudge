library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jtag_tap is
    port (
        tck        : in  std_logic;
        trst       : in  std_logic;
        tms        : in  std_logic;
        state      : out std_logic_vector(3 downto 0);
        shift_dr   : out std_logic;
        shift_ir   : out std_logic;
        capture_dr : out std_logic;
        update_dr  : out std_logic;
        tlr        : out std_logic
    );
end entity;

architecture rtl of jtag_tap is
begin

    -- Your code here

end architecture;
