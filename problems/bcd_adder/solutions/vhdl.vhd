library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_add is
    port (a, b : in std_logic_vector(3 downto 0); cin : in std_logic;
          sum : out std_logic_vector(3 downto 0); cout : out std_logic);
end entity;

architecture rtl of bcd_add is
    signal bin, adj : unsigned(4 downto 0);
    signal c : std_logic;
begin
    bin <= resize(unsigned(a), 5) + resize(unsigned(b), 5) + ("0000" & cin);
    c <= '1' when bin > 9 else '0';
    adj <= bin + 6 when c = '1' else bin;
    sum <= std_logic_vector(adj(3 downto 0));
    cout <= c;
end architecture;
