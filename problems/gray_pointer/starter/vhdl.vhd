library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rd_ptr_gray is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        rd_en        : in  std_logic;
        wr_gray_sync : in  std_logic_vector(3 downto 0);
        rd_gray      : out std_logic_vector(3 downto 0);
        rd_addr      : out std_logic_vector(2 downto 0);
        empty        : out std_logic
    );
end entity;

architecture rtl of rd_ptr_gray is
begin

    -- Your code here

end architecture;
