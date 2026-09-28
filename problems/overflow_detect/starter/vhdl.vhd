library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub_flags is
    port (
        a     : in  std_logic_vector(7 downto 0);
        b     : in  std_logic_vector(7 downto 0);
        sub   : in  std_logic;
        y     : out std_logic_vector(7 downto 0);
        carry : out std_logic;
        ovf   : out std_logic
    );
end entity;

architecture rtl of addsub_flags is
begin

    -- Your code here

end architecture;
