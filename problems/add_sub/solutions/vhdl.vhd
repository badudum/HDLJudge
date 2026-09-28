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
    signal t : unsigned(N downto 0);
begin
    t <= ('0' & unsigned(a)) + ('0' & unsigned(b xor (N-1 downto 0 => sub))) + ("" & sub);
    y <= std_logic_vector(t(N-1 downto 0));
    cout <= t(N);
end architecture;
