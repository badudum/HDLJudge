library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_counter is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick_ms : in  std_logic;
        load    : in  std_logic;
        ld_ms   : in  std_logic_vector(9 downto 0);
        ld_sec  : in  std_logic_vector(5 downto 0);
        ld_min  : in  std_logic_vector(5 downto 0);
        ld_hr   : in  std_logic_vector(4 downto 0);
        ms      : out std_logic_vector(9 downto 0);
        sec     : out std_logic_vector(5 downto 0);
        min     : out std_logic_vector(5 downto 0);
        hr      : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of time_counter is
begin

    -- Your code here

end architecture;
