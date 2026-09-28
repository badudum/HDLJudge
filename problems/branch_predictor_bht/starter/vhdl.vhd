library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bht is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        pc     : in  std_logic_vector(7 downto 0);
        update : in  std_logic;
        upd_pc : in  std_logic_vector(7 downto 0);
        taken  : in  std_logic;
        pred   : out std_logic;
        ctr    : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of bht is
begin

    -- Your code here

end architecture;
