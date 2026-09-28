library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_invert is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        valid   : in  std_logic;
        din     : in  std_logic_vector(7 downto 0);
        bus_q   : out std_logic_vector(7 downto 0);
        inv     : out std_logic;
        dout    : out std_logic_vector(7 downto 0);
        toggles : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of bus_invert is
begin

    -- Your code here

end architecture;
