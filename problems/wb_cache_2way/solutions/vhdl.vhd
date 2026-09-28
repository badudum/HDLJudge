library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_cache is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        req       : in  std_logic;
        we        : in  std_logic;
        addr      : in  std_logic_vector(5 downto 0);
        wdata     : in  std_logic_vector(7 downto 0);
        mem_rdata : in  std_logic_vector(7 downto 0);
        hit       : out std_logic;
        rdata     : out std_logic_vector(7 downto 0);
        wb_valid  : out std_logic;
        wb_addr   : out std_logic_vector(5 downto 0);
        wb_data   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of wb_cache is
    type tag_t is array (0 to 7) of std_logic_vector(3 downto 0);
    type dat_t is array (0 to 7) of std_logic_vector(7 downto 0);
    signal v, d : std_logic_vector(7 downto 0) := (others => '0');
    signal t    : tag_t;
    signal x    : dat_t;
    signal lru  : std_logic_vector(3 downto 0) := (others => '0');
begin
    process (clk)
        variable s : natural range 0 to 3;
        variable h0, h1 : boolean;
        variable way : natural range 0 to 1;
        variable e : natural range 0 to 7;
    begin
        if rising_edge(clk) then
            s := to_integer(unsigned(addr(1 downto 0)));
            h0 := v(2*s) = '1' and t(2*s) = addr(5 downto 2);
            h1 := v(2*s + 1) = '1' and t(2*s + 1) = addr(5 downto 2);
            if h1 then way := 1;
            elsif h0 then way := 0;
            elsif v(2*s) = '0' then way := 0;
            elsif v(2*s + 1) = '0' then way := 1;
            elsif lru(s) = '1' then way := 1;
            else way := 0;
            end if;
            e := 2*s + way;
            if rst = '1' then
                v <= (others => '0'); d <= (others => '0'); lru <= (others => '0');
                hit <= '0'; wb_valid <= '0';
            elsif req = '1' then
                if way = 0 then lru(s) <= '1'; else lru(s) <= '0'; end if;
                wb_valid <= '0';
                if h0 or h1 then
                    hit <= '1';
                    rdata <= x(e);
                    if we = '1' then x(e) <= wdata; d(e) <= '1'; end if;
                else
                    hit <= '0';
                    if v(e) = '1' and d(e) = '1' then
                        wb_valid <= '1'; wb_addr <= t(e) & addr(1 downto 0); wb_data <= x(e);
                    end if;
                    v(e) <= '1'; t(e) <= addr(5 downto 2); d(e) <= we;
                    if we = '1' then x(e) <= wdata; else x(e) <= mem_rdata; end if;
                    rdata <= mem_rdata;
                end if;
            else
                hit <= '0'; wb_valid <= '0';
            end if;
        end if;
    end process;
end architecture;
