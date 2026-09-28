library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity refill_fsm is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        miss        : in  std_logic;
        dirty       : in  std_logic;
        miss_line   : in  std_logic_vector(7 downto 0);
        victim_line : in  std_logic_vector(7 downto 0);
        mem_ack     : in  std_logic;
        mem_req     : out std_logic;
        mem_we      : out std_logic;
        mem_addr    : out std_logic_vector(9 downto 0);
        done        : out std_logic
    );
end entity;

architecture rtl of refill_fsm is
begin

    -- Your code here

end architecture;
