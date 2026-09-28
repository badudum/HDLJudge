library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity thread_mask is
    port (
        active     : in  std_logic_vector(7 downto 0);
        cond       : in  std_logic_vector(7 downto 0);
        taken      : out std_logic_vector(7 downto 0);
        not_taken  : out std_logic_vector(7 downto 0);
        divergent  : out std_logic;
        first_lane : out std_logic_vector(2 downto 0);
        any_active : out std_logic
    );
end entity;

architecture rtl of thread_mask is
    signal t, n : std_logic_vector(7 downto 0);
begin
    t <= active and cond;
    n <= active and not cond;
    taken <= t;
    not_taken <= n;
    divergent  <= (or t) and (or n);
    any_active <= or active;
    process (active)
        variable k : natural range 0 to 7;
    begin
        k := 0;
        for i in 7 downto 0 loop
            if active(i) = '1' then k := i; end if;
        end loop;
        first_lane <= std_logic_vector(to_unsigned(k, 3));
    end process;
end architecture;
