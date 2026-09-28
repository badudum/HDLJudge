library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity drowsy_array is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        req     : in  std_logic;
        we      : in  std_logic;
        idx     : in  std_logic_vector(2 downto 0);
        wdata   : in  std_logic_vector(7 downto 0);
        ready   : out std_logic;
        rdata   : out std_logic_vector(7 downto 0);
        drowsy  : out std_logic_vector(7 downto 0);
        wakeups : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of drowsy_array is
begin

    -- Your code here

end architecture;
