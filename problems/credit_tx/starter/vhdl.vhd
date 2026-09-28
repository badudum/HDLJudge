library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity credit_tx is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        in_valid   : in  std_logic;
        in_data    : in  std_logic_vector(7 downto 0);
        in_ready   : out std_logic;
        tx_valid   : out std_logic;
        tx_data    : out std_logic_vector(7 downto 0);
        credit_ret : in  std_logic;
        credits    : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of credit_tx is
begin

    -- Your code here

end architecture;
