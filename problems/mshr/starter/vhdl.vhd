library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mshr4 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        miss_valid : in  std_logic;
        miss_addr  : in  std_logic_vector(7 downto 0);
        resp_valid : in  std_logic;
        resp_id    : in  std_logic_vector(1 downto 0);
        mem_req    : out std_logic;
        mem_id     : out std_logic_vector(1 downto 0);
        mem_addr   : out std_logic_vector(7 downto 0);
        merged     : out std_logic;
        merge_id   : out std_logic_vector(1 downto 0);
        stall      : out std_logic;
        valid_mask : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of mshr4 is
begin

    -- Your code here

end architecture;
