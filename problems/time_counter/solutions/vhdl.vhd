library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_counter is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick_ms : in  std_logic;
        load    : in  std_logic;
        ld_ms   : in  std_logic_vector(9 downto 0);
        ld_sec  : in  std_logic_vector(5 downto 0);
        ld_min  : in  std_logic_vector(5 downto 0);
        ld_hr   : in  std_logic_vector(4 downto 0);
        ms      : out std_logic_vector(9 downto 0);
        sec     : out std_logic_vector(5 downto 0);
        min     : out std_logic_vector(5 downto 0);
        hr      : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of time_counter is
    signal m  : unsigned(9 downto 0) := (others => '0');
    signal s, mi : unsigned(5 downto 0) := (others => '0');
    signal h  : unsigned(4 downto 0) := (others => '0');
begin
    ms <= std_logic_vector(m); sec <= std_logic_vector(s); min <= std_logic_vector(mi); hr <= std_logic_vector(h);
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                m <= (others => '0'); s <= (others => '0'); mi <= (others => '0'); h <= (others => '0');
            elsif load = '1' then
                m <= unsigned(ld_ms); s <= unsigned(ld_sec); mi <= unsigned(ld_min); h <= unsigned(ld_hr);
            elsif tick_ms = '1' then
                if m = 999 then
                    m <= (others => '0');
                    if s = 59 then
                        s <= (others => '0');
                        if mi = 59 then
                            mi <= (others => '0');
                            if h = 23 then h <= (others => '0'); else h <= h + 1; end if;
                        else
                            mi <= mi + 1;
                        end if;
                    else
                        s <= s + 1;
                    end if;
                else
                    m <= m + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
