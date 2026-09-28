library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        rx        : in  std_logic;
        data      : out std_logic_vector(7 downto 0);
        valid     : out std_logic;
        frame_err : out std_logic
    );
end entity;

architecture rtl of uart_rx is
begin

    -- Your code here

end architecture;
