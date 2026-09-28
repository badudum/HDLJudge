library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_fifo is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        wr_en : in  std_logic;
        din   : in  std_logic_vector(7 downto 0);
        rd_en : in  std_logic;
        dout  : out std_logic_vector(7 downto 0);
        full  : out std_logic;
        empty : out std_logic;
        count : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of sync_fifo is
    type mem_t is array (0 to 7) of std_logic_vector(7 downto 0);
    signal mem    : mem_t;
    signal wp, rp : unsigned(2 downto 0) := (others => '0');
    signal cnt    : unsigned(3 downto 0) := (others => '0');
    signal do_wr, do_rd : std_logic;
begin
    do_wr <= '1' when wr_en = '1' and cnt /= 8 else '0';
    do_rd <= '1' when rd_en = '1' and cnt /= 0 else '0';

    count <= std_logic_vector(cnt);
    full  <= '1' when cnt = 8 else '0';
    empty <= '1' when cnt = 0 else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if do_wr = '1' then
                mem(to_integer(wp)) <= din;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wp <= (others => '0'); rp <= (others => '0');
                cnt <= (others => '0'); dout <= (others => '0');
            else
                if do_wr = '1' then wp <= wp + 1; end if;
                if do_rd = '1' then
                    dout <= mem(to_integer(rp));
                    rp <= rp + 1;
                end if;
                if do_wr = '1' and do_rd = '0' then cnt <= cnt + 1;
                elsif do_wr = '0' and do_rd = '1' then cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
