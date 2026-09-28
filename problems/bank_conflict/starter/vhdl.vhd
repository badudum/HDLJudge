library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_conflict is
    port (
        addr     : in  std_logic_vector(31 downto 0);
        valid    : in  std_logic_vector(3 downto 0);
        conflict : out std_logic;
        cycles   : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of bank_conflict is
begin

    -- Your code here

end architecture;
