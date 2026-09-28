library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity way_pred is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        req       : in  std_logic;
        addr      : in  std_logic_vector(5 downto 0);
        pred      : out std_logic;
        fast_hit  : out std_logic;
        slow_hit  : out std_logic;
        miss      : out std_logic;
        tag_reads : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of way_pred is
    type tag_t is array (0 to 7) of std_logic_vector(3 downto 0);
    signal v   : std_logic_vector(7 downto 0) := (others => '0');
    signal t   : tag_t;
    signal mru : std_logic_vector(3 downto 0) := (others => '0');
    signal rd  : unsigned(15 downto 0) := (others => '0');
begin
    tag_reads <= std_logic_vector(rd);
    process (clk)
        variable s : natural range 0 to 3;
        variable p, o, w : natural range 0 to 1;
        variable hp, ho : boolean;
    begin
        if rising_edge(clk) then
            s := to_integer(unsigned(addr(1 downto 0)));
            if mru(s) = '1' then p := 1; else p := 0; end if;
            o := 1 - p;
            hp := v(2*s + p) = '1' and t(2*s + p) = addr(5 downto 2);
            ho := v(2*s + o) = '1' and t(2*s + o) = addr(5 downto 2);
            if rst = '1' then
                v <= (others => '0'); mru <= (others => '0'); pred <= '0';
                fast_hit <= '0'; slow_hit <= '0'; miss <= '0'; rd <= (others => '0');
            elsif req = '1' then
                if p = 1 then pred <= '1'; else pred <= '0'; end if;
                fast_hit <= '0'; slow_hit <= '0'; miss <= '0';
                if hp then
                    fast_hit <= '1'; w := p; rd <= rd + 1;
                elsif ho then
                    slow_hit <= '1'; w := o; rd <= rd + 2;
                else
                    miss <= '1'; rd <= rd + 2;
                    if v(2*s) = '0' then w := 0; elsif v(2*s + 1) = '0' then w := 1; else w := o; end if;
                    v(2*s + w) <= '1'; t(2*s + w) <= addr(5 downto 2);
                end if;
                if w = 1 then mru(s) <= '1'; else mru(s) <= '0'; end if;
            else
                fast_hit <= '0'; slow_hit <= '0'; miss <= '0';
            end if;
        end if;
    end process;
end architecture;
