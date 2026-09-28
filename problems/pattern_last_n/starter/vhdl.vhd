library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity last_n_ones is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        din   : in  std_logic;
        count : out std_logic_vector(3 downto 0);
        alarm : out std_logic
    );
end entity;

architecture rtl of last_n_ones is
begin

    -- Your code here

end architecture;
