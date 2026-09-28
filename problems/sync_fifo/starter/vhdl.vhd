library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_fifo is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        wr_en : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        rd_en : in  std_logic;
        dout  : out std_logic_vector(7 downto 0);
        full  : out std_logic;
        empty : out std_logic;
        count : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of sync_fifo is
begin

    -- Your code here

end architecture;
