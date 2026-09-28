library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity irq_ctrl is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        irq_in    : in  std_logic_vector(7 downto 0);
        mask_we   : in  std_logic;
        mask_data : in  std_logic_vector(7 downto 0);
        ack       : in  std_logic;
        irq       : out std_logic;
        id        : out std_logic_vector(2 downto 0);
        pending   : out std_logic_vector(7 downto 0);
        mask      : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of irq_ctrl is
begin

    -- Your code here

end architecture;
