-- Correct, but too slow: the synthesizer's generic adder is 16 levels deep.
-- Replace it with a carry network that meets the 12-level budget.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fast_add16 is
    port (
        a    : in  std_logic_vector(15 downto 0);
        b    : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(15 downto 0);
        cout : out std_logic
    );
end entity;

architecture rtl of fast_add16 is
    signal sum : unsigned(16 downto 0);
begin
    sum  <= ('0' & unsigned(a)) + ('0' & unsigned(b)) + ("" & cin);
    s    <= std_logic_vector(sum(15 downto 0));
    cout <= sum(16);
end architecture;
