-- Functionally correct, but far too slow: the loop builds a 63-gate XOR chain.
-- Restructure it to meet the 8-level timing budget.
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
    process (d)
        variable acc : std_logic;
    begin
        acc := '0';
        for i in 0 to 63 loop
            acc := acc xor d(i);
        end loop;
        p <= acc;
    end process;
end architecture;
