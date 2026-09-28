library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity onehot_check is
    port (
        x       : in  std_logic_vector(15 downto 0);
        onehot  : out std_logic;
        onehot0 : out std_logic
    );
end entity;

architecture rtl of onehot_check is
begin

    -- Your code here

end architecture;
