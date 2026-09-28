library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ao_ctrl is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        sleep_req : in  std_logic;
        wake_irq  : in  std_logic;
        pmu_ack   : in  std_logic;
        pmu_req   : out std_logic;
        asleep    : out std_logic;
        irq_out   : out std_logic
    );
end entity;

architecture rtl of ao_ctrl is
begin

    -- Your code here

end architecture;
