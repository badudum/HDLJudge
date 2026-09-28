library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic;
        tx_data : in  std_logic_vector(7 downto 0);
        miso    : in  std_logic;
        sclk    : out std_logic;
        mosi    : out std_logic;
        cs_n    : out std_logic;
        busy    : out std_logic;
        done    : out std_logic;
        rx_data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of spi_master is
begin

    -- Your code here

end architecture;
