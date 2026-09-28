library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scoreboard is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        issue_valid : in  std_logic;
        rd          : in  std_logic_vector(2 downto 0);
        rs1         : in  std_logic_vector(2 downto 0);
        rs2         : in  std_logic_vector(2 downto 0);
        wb_valid    : in  std_logic;
        wb_rd       : in  std_logic_vector(2 downto 0);
        issued      : out std_logic;
        pending     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of scoreboard is
begin

    -- Your code here

end architecture;
