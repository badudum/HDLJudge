library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    generic (
        N : positive := 8
    );
    port (
        a    : in  std_logic_vector(N-1 downto 0);
        b    : in  std_logic_vector(N-1 downto 0);
        sub  : in  std_logic;
        y    : out std_logic_vector(N-1 downto 0);
        cout : out std_logic
    );
end entity;

architecture rtl of add_sub is
begin

    -- Your code here

end architecture;
