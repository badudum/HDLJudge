library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfu4 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        hit    : in  std_logic;
        way    : in  std_logic_vector(1 downto 0);
        fill   : in  std_logic;
        victim : out std_logic_vector(1 downto 0);
        counts : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of lfu4 is
    type cnt_t is array (0 to 3) of unsigned(2 downto 0);
    signal c : cnt_t := (others => (others => '0'));
    signal v : natural range 0 to 3;
begin
    counts <= std_logic_vector(c(3)) & std_logic_vector(c(2)) & std_logic_vector(c(1)) & std_logic_vector(c(0));
    victim <= std_logic_vector(to_unsigned(v, 2));

    process (c)
        variable k : natural range 0 to 3;
    begin
        k := 0;
        for i in 1 to 3 loop
            if c(i) < c(k) then k := i; end if;
        end loop;
        v <= k;
    end process;

    process (clk)
        variable w   : natural range 0 to 3;
        variable inc : unsigned(2 downto 0);
    begin
        if rising_edge(clk) then
            w := to_integer(unsigned(way));
            if c(w) = 7 then inc := c(w); else inc := c(w) + 1; end if;
            if rst = '1' then
                c <= (others => (others => '0'));
            elsif fill = '1' then
                c(v) <= "001";
            elsif hit = '1' then
                if inc = 7 then
                    for i in 0 to 3 loop
                        if i = w then c(i) <= shift_right(inc, 1); else c(i) <= shift_right(c(i), 1); end if;
                    end loop;
                else
                    c(w) <= inc;
                end if;
            end if;
        end if;
    end process;
end architecture;
