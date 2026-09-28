library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bht is
    port (clk, rst : in std_logic; pc : in std_logic_vector(7 downto 0); update : in std_logic;
          upd_pc : in std_logic_vector(7 downto 0); taken : in std_logic;
          pred : out std_logic; ctr : out std_logic_vector(1 downto 0));
end entity;

architecture rtl of bht is
    type t_t is array (0 to 15) of unsigned(1 downto 0);
    signal t : t_t := (others => "01");
    signal c : unsigned(1 downto 0);
begin
    c <= t(to_integer(unsigned(pc(5 downto 2))));
    ctr <= std_logic_vector(c);
    pred <= c(1);
    process (clk)
        variable i : natural range 0 to 15;
    begin
        if rising_edge(clk) then
            i := to_integer(unsigned(upd_pc(5 downto 2)));
            if rst = '1' then
                t <= (others => "01");
            elsif update = '1' then
                if taken = '1' and t(i) /= 3 then t(i) <= t(i) + 1;
                elsif taken = '0' and t(i) /= 0 then t(i) <= t(i) - 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
