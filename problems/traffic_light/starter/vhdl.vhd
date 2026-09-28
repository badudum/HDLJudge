library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_light is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        car  : in  std_logic;
        main : out std_logic_vector(1 downto 0);
        side : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of traffic_light is
begin

    -- Your code here

end architecture;
