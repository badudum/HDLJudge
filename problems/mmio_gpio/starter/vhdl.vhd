library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mmio_gpio is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        we       : in  std_logic;
        addr     : in  std_logic_vector(1 downto 0);
        wdata    : in  std_logic_vector(7 downto 0);
        rdata    : out std_logic_vector(7 downto 0);
        gpio_in  : in  std_logic_vector(7 downto 0);
        gpio_out : out std_logic_vector(7 downto 0);
        gpio_oe  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of mmio_gpio is
begin

    -- Your code here

end architecture;
