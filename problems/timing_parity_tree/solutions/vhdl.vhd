library ieee;
use ieee.std_logic_1164.all;

entity parity64 is
    port (
        d : in  std_logic_vector(63 downto 0);
        p : out std_logic
    );
end entity;

architecture rtl of parity64 is
begin
    p <= xor d;     -- VHDL-2008 reduction operator
end architecture;
