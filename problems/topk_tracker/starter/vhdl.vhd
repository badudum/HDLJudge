library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top3 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        valid : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        t0    : out std_logic_vector(7 downto 0);
        t1    : out std_logic_vector(7 downto 0);
        t2    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of top3 is
begin

    -- Your code here

end architecture;
