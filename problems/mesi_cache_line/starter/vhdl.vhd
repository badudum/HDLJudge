library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mesi_line is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        pr_rd     : in  std_logic;
        pr_wr     : in  std_logic;
        bus_rd    : in  std_logic;
        bus_rdx   : in  std_logic;
        shared_in : in  std_logic;
        state     : out std_logic_vector(1 downto 0);
        wb        : out std_logic
    );
end entity;

architecture rtl of mesi_line is
begin

    -- Your code here

end architecture;
