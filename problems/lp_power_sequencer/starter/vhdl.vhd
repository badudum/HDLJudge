library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwr_seq is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        sleep_req : in  std_logic;
        wake_req  : in  std_logic;
        pwr_ack   : in  std_logic;
        clk_en    : out std_logic;
        iso_en    : out std_logic;
        save      : out std_logic;
        restore   : out std_logic;
        pwr_en    : out std_logic;
        asleep    : out std_logic
    );
end entity;

architecture rtl of pwr_seq is
begin

    -- Your code here

end architecture;
