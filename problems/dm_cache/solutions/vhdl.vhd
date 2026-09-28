library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dm_cache is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        rd        : in  std_logic;
        wr        : in  std_logic;
        fill      : in  std_logic;
        inv       : in  std_logic;
        addr      : in  std_logic_vector(7 downto 0);
        wdata     : in  std_logic_vector(7 downto 0);
        fill_data : in  std_logic_vector(7 downto 0);
        hit       : out std_logic;
        rdata     : out std_logic_vector(7 downto 0);
        hits      : out std_logic_vector(7 downto 0);
        misses    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of dm_cache is
    type tag_t is array (0 to 7) of std_logic_vector(4 downto 0);
    type dat_t is array (0 to 7) of std_logic_vector(7 downto 0);
    signal valid : std_logic_vector(7 downto 0) := (others => '0');
    signal tags  : tag_t;
    signal data  : dat_t;
    signal nh, nm : unsigned(7 downto 0) := (others => '0');
begin
    hits <= std_logic_vector(nh);
    misses <= std_logic_vector(nm);
    process (clk)
        variable i : natural range 0 to 7;
        variable m : boolean;
    begin
        if rising_edge(clk) then
            i := to_integer(unsigned(addr(2 downto 0)));
            m := valid(i) = '1' and tags(i) = addr(7 downto 3);
            if rst = '1' then
                valid <= (others => '0'); hit <= '0'; nh <= (others => '0'); nm <= (others => '0');
            else
                if (rd = '1' or wr = '1') and m then hit <= '1'; else hit <= '0'; end if;
                rdata <= data(i);
                if rd = '1' then
                    if m then nh <= nh + 1; else nm <= nm + 1; end if;
                end if;
                if wr = '1' and m then data(i) <= wdata; end if;
                if fill = '1' then
                    valid(i) <= '1'; tags(i) <= addr(7 downto 3); data(i) <= fill_data;
                end if;
                if inv = '1' then valid <= (others => '0'); end if;
            end if;
        end if;
    end process;
end architecture;
