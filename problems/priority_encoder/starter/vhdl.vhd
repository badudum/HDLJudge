library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prio_enc8 is
    port (
        req   : in  std_logic_vector(7 downto 0);
        idx   : out std_logic_vector(2 downto 0);
        valid : out std_logic
    );
end entity;

architecture rtl of prio_enc8 is
begin

    -- Your code here

end architecture;
