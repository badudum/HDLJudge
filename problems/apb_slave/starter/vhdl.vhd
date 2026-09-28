library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apb_slave is
    port (
        pclk    : in  std_logic;
        presetn : in  std_logic;
        psel    : in  std_logic;
        penable : in  std_logic;
        pwrite  : in  std_logic;
        paddr   : in  std_logic_vector(7 downto 0);
        pwdata  : in  std_logic_vector(31 downto 0);
        pstrb   : in  std_logic_vector(3 downto 0);
        prdata  : out std_logic_vector(31 downto 0);
        pready  : out std_logic;
        pslverr : out std_logic
    );
end entity;

architecture rtl of apb_slave is
begin

    -- Your code here

end architecture;
